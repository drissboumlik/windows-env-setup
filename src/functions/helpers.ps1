
function Get-User-Path {
    param ($readFromEnvFile = $false)

    $path = $null

    if ($readFromEnvFile -and (Test-Path $ENV_FILE)) {
        Get-Content $ENV_FILE | ForEach-Object {
            if ($_ -match "^USER_ENV_PATH=(.*)$") {
                $path = $matches[1].Trim()
            }
        }
    } else {
        $path = Read-Host "Where would you like to download the tools? (default: $USER_ENV_PATH)"
    }

    if ([string]::IsNullOrWhiteSpace($path)) {
        $path = $USER_ENV_PATH
    }

    if ($path -and $path -notmatch '^[A-Za-z]:\\.+') {
        Write-Host "Invalid path. Please provide a valid absolute path (e.g., C:\dev-tools)."
        return $null
    }

    $path = $path.Trim()

    "USER_ENV_PATH=$path" | Set-Content -Path $ENV_FILE -Encoding UTF8

    return $path
}

function Restore-Or-BackupFile {
    param ($filePath)

    $backupFile = "$filePath.bak"

    if (Test-Path $backupFile) {
        Copy-Item -Path $backupFile -Destination $filePath -Force
    }
    else {
        Copy-Item -Path $filePath -Destination $backupFile -Force
    }
}

function Log-Data {
    param ($data)

    try {
        $logPath = if ($data.logPath) { $data.logPath } else { $LOG_ERROR_PATH }
        $created = Make-Directory -path (Split-Path $logPath)
        if ($created -ne 0) {
            Write-Host "Failed to create directory $(Split-Path $logPath)"
            return -1
        }
        $content = "`n--------------------------"
        $content += "`n[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $($data.header)"
        if ($data.exception) {
            $content += "`nMessage: $($data.exception.Exception.Message)"
            $content += "`nPosition: $($data.exception.InvocationInfo.PositionMessage)"
        }
        Add-Content -Path $logPath -Value $content
        return 0
    } catch {
        return -1
    }
}

function Get-User-Answers {

    $StepsQuestions = [ordered]@{
        GIT = @{ Question = "- Download Git ?"; Answer = "no" }
        NVM = @{ Question = "- Download NVM (Node Version Manager) ?"; Answer = "no" }
        "PVM/COMPOSER" = @{ Question = "- Download PVM (PHP Version Manager) & Composer ?"; Answer = "no" }
        SCRIPTS = @{ Question = "- Download user scripts ?"; Answer = "no" }
        REDIS = @{ Question = "- Download Redis ?"; Answer = "no" }
        TOOLS = @{ Question = "- Download TOOLS (eza, delta, bat, fzf, zoxide, tldr, Fd, Ripgrep, Starship, Jq, Yq, Tree, Curl, Wget) ?"; Answer = "no" }
        CMDER = @{ Question = "- Download & Configure Cmder ?"; Answer = "no" }
        FONTS = @{ Question = "- Download Nerd Fonts ?"; Answer = "no" }
    }

    foreach ($key in $StepsQuestions.Keys) {
        $q = $StepsQuestions[$key]
        $q.Answer = Prompt-YesOrNoWithDefault -message $q.Question -defaultOption "yes"
    }

    return $StepsQuestions
}

function Get-Followup-Answers {
    $StepsQuestions = [ordered]@{
        CMDER = @{ Question = "- Did you already start cmder ?"; Answer = "no" }
    }

    foreach ($key in $StepsQuestions.Keys) {
        $q = $StepsQuestions[$key]
        $q.Answer = Prompt-YesOrNoWithDefault -message $q.Question -defaultOption "no"
    }

    return $StepsQuestions
}

function Install-Chocolatey {
    try {
        Write-Host "`nDownloading and installing Chocolatey..."

        if (Is-Tool-Installed -name 'choco') {
            return @{ code = 0; messages = @( Set-Success-Message -message 'Chocolatey is already installed' ) }
        }

        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("")) | Out-Null

        return @{ code = 0; messages = @(Set-Success-Message -message "Chocolatey installed successfully") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Chocolatey failed to install"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message "Chocolatey failed or is already installed, try again") }
    }
}

function Set-Todo-Message {
    param ( $message )

    $message = ($message.split("`n") | ForEach-Object { "- $($_.TrimEnd())" }) -join "`n"

    return @{
        Message = $message
        ForegroundColor = "White"
        BackgroundColor = "Black"
    }
}

function Set-Success-Message {
    param ( $message )

    $message = ($message.split("`n") | ForEach-Object { "- $($_.TrimEnd()) :)" }) -join "`n"

    return @{
        Message = $message
        ForegroundColor = "DarkGreen"
        BackgroundColor = "Black"
    }
}

function Set-Error-Message {
    param ( $message, $exceptionMessage = $null )

    $message = ($message.split("`n") | ForEach-Object { "- $($_.TrimEnd()) :(" }) -join "`n"
    if ($exceptionMessage) {
        $message += "`n    --> $exceptionMessage"
    }

    return @{
        Message = $message
        ForegroundColor = "DarkYellow"
        BackgroundColor = "Black"
    }
}

function Download-File {
    param ( $url, $output )

    try {
        Invoke-WebRequest -Uri $url -OutFile $output

        return 0
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to download file from $url"; exception = $_ }
        return -1
    }
}

function Run-Command {
    param($filePath, $arguments)

    $process = Start-Process `
        -FilePath $filePath `
        -ArgumentList $arguments `
        -Verb RunAs `
        -PassThru `
        -Wait `
        -WindowStyle Hidden

    return $process.ExitCode
}

function Run-PS-Command {
    param($command)

    $process = Start-Process `
        -FilePath "powershell.exe" `
        -ArgumentList @(
            "-NoProfile",
            "-ExecutionPolicy", "Bypass",
            "-Command", $command
        ) `
        -Verb RunAs `
        -PassThru `
        -Wait `
        -WindowStyle Hidden

    return $process.ExitCode
}

function Is-Tool-Installed {
    param ($name)

    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Is-Directory-Exists {
    param ($path)

    try {
        if ([string]::IsNullOrWhiteSpace($path)) {
            return $false
        }
        $path = $path.Trim()
        return (Test-Path -Path $path -PathType Container)
    } catch {
        return $false
    }
}

function Make-Directory {
    param ( $path )

    try {
        if ([string]::IsNullOrWhiteSpace($path)) {
            return -1
        }

        $path = $path.Trim()
        if (-not (Is-Directory-Exists -path $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
        }

        return 0
    } catch {
        return -1
    }
}

function Extract-Zip {
    param ( $zipPath, $extractPath )
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)

        return 0
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to extract zip file from $zipPath"; exception = $_ }
        return -1
    }
}

function Ensure-PackageInstalled {
    param($name, $chocoName)

    try {
        if (Is-Tool-Installed -name $name) {
            return @{ code = 0; message = "$name already available" }
        }
        
        if (-not (Is-Admin)) {
            $code = Run-Command -filePath 'choco' -arguments @('install', $chocoName, '-y')
        } else {
            choco install $chocoName -y > $null 2>&1
        }

        if (Is-Tool-Installed -name $name) {
            return @{ code = 0; message = "$chocoName installed" }
        } else {
            $logged = Log-Data -data @{ header = "Ensure-PackageInstalled - Failed to install $chocoName"; exception = $null }
            return @{ code = -1; message = "Failed to install $chocoName" }
        }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to install $chocoName"; exception = $_ }
        return @{ code = -1; message = "Exception while installing $chocoName" }
    }
}

function Prompt-YesOrNoWithDefault {
    param(
        $message = 'Do you want to continue ? (yes/no)',
        [ValidateSet("yes", "no")]
        $defaultOption = "no"
    )

    $promptMessage = "$message (Default: $defaultOption)"
    $response = Read-Host $promptMessage

    if ($response -eq "" -or $response -eq $defaultOption) {
        return $defaultOption
    } elseif ($response -eq "yes" -or $response -eq "y") {
        return "yes"
    } elseif ($response -eq "no" -or $response -eq "n") {
        return "no"
    } else {
        Write-Host "Invalid input. Please enter 'yes' or 'no'."
        return Prompt-YesOrNoWithDefault -message $message -defaultOption $defaultOption
    }
}

function Append-To-Env-Variable {
    param ( $entry, $targetVariable, $asVarRef = 1 )

    $code = Update-Env-Variable -entry $entry -targetVariable $targetVariable -asVarRef $asVarRef -remove 0
    return $code
}

function Remove-From-Env-Variable {
    param ( $entry, $targetVariable, $asVarRef = 1 )

    $code = Update-Env-Variable -entry $entry -targetVariable $targetVariable -asVarRef $asVarRef -remove 1
    return $code
}

function Update-Env-Variable {
    param( $entry, $targetVariable, $asVarRef = 1, $remove = 0 )

    $resolvedEntry = if ($asVarRef -eq 1) { "%$entry%" } else { $entry }
    $currentValue = [System.Environment]::GetEnvironmentVariable($targetVariable, [System.EnvironmentVariableTarget]::Machine)
    $entries = @($currentValue -split ";" | Where-Object { $_ -ne "" })
    if ($remove -eq 1) {
        $updated = @($entries | Where-Object { $_ -ne $resolvedEntry })
        if ($updated.Count -eq $entries.Count) {
            Write-Warning "Entry '$resolvedEntry' not found in $TargetVariable — nothing removed."
            return -1
        }
    } else {
        if ($resolvedEntry -in $entries) {
            Write-Warning "Entry '$entry' already exists in $TargetVariable — skipping."
            return -1
        }
        $updated = @($entries + $resolvedEntry)
    }
    $newValue = $updated -join ";"
    $output = Set-EnvVar -name $targetVariable -value $newValue

    return $output
}

function Update-Path-Env-Variable {
    param( $entry, $asVarRef = 1, $remove = 0 )

    $code = Update-Env-Variable -entry $entry -targetVariable "PATH" -asVarRef $asVarRef -remove $remove
    $optimized = Optimize-SystemPath

    return $code
}

function Print-Messages {
    param( $messages = @(), $todos = @() )

    if ($messages.Count -gt 0) {
        Write-Host "`n==========================================================================================`n"
        Write-Host "# Results :"
        foreach ($msg in $messages) {
            Write-Host $msg.Message -ForegroundColor $msg.ForegroundColor -BackgroundColor $msg.BackgroundColor
        }
    }
    if ($todos.Count -gt 0) {
        Write-Host "`n==========================================================================================`n"
        Write-Host "# Todos :"
        foreach ($msg in $todos) {
            Write-Host $msg.Message -ForegroundColor $msg.ForegroundColor -BackgroundColor $msg.BackgroundColor
        }
    }
    Write-Host "`n==========================================================================================`n"
    Write-Host "`nAll tasks completed.`n`n"
}

function Is-Admin {

    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    return $isAdmin
}

function Get-All-EnvVars {
    try {
        return [System.Environment]::GetEnvironmentVariables([System.EnvironmentVariableTarget]::Machine)
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to get all environment variables"; exception = $_ }
        return $null
    }
}

function Get-EnvVar-ByName {
    param ($name)

    try {
        if ([string]::IsNullOrWhiteSpace($name)) {
            return $null
        }
        $name = $name.Trim()
        return [System.Environment]::GetEnvironmentVariable($name, [System.EnvironmentVariableTarget]::Machine)
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to get environment variable '$name'"; exception = $_ }
        return $null
    }
}

function Set-EnvVar {
    param ($name, $value)

    try {
        if ([string]::IsNullOrWhiteSpace($name)) {
            return -1
        }
        $name = $name.Trim()

        if (-not (Is-Admin)) {
            $command = "[System.Environment]::SetEnvironmentVariable('$name', '$value', [System.EnvironmentVariableTarget]::Machine)"
            return (Run-PS-Command -command $command)
        }

        # We already have admin rights, proceed normally
        [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Machine)
        return 0
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to set environment variable '$name'"; exception = $_ }
        return -1
    }
}

function Optimize-SystemPath {

    try {
        $path = Get-EnvVar-ByName -name "Path"
        if ($null -eq $path) {
            $path = ''
        }
        $oldPath = $path
        $envVars = Get-All-EnvVars

        $envVars.Keys | ForEach-Object {
            $envName = $_
            $envValue = $envVars[$envName]

            if (
                ($null -ne $envValue) -and
                ($path.ToLower() -like "*$($envValue.ToLower())*") -and
                -not($envValue -match '(?i)\\Windows') -and
                -not($envValue -match '(?i)\\System32')
            ) {
                $envValue = [regex]::Escape($envValue.TrimEnd(';'))
                $pattern = "(?i)(?<=^|;){0}(?=;|$)" -f $envValue
                $path = [regex]::Replace($path, $pattern, "%$envName%")
            }
        }

        $output = 0
        if ($path -ne $oldPath) {
            # Saving Path to log
            $outputLog = Log-Data -data @{
                logPath = $PATH_VAR_BACKUP_PATH
                header = "Original PATH`n$oldPath"
            }
            if ($outputLog -eq 0) {
                Write-Host "`nOriginal Path saved to '$PATH_VAR_BACKUP_PATH'"
            }

            $output = Set-EnvVar -name "Path" -value $path
            if ($output -eq 0) {
                Write-Host "`nPath optimized successfully" -ForegroundColor DarkGreen
            }
        }

        return $output
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to optimize system PATH variable"; exception = $_ }
        return -1
    }
}
