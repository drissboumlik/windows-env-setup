
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
        GIT = [PSCustomObject]@{ Question = "- Download Git ?"; Answer = "no" }
        NVM = [PSCustomObject]@{ Question = "- Download NVM (Node Version Manager) ?"; Answer = "no" }
        "PVM/COMPOSER" = [PSCustomObject]@{ Question = "- Download PVM (PHP Version Manager) & Composer ?"; Answer = "no" }
        SCRIPTS = [PSCustomObject]@{ Question = "- Download user scripts ?"; Answer = "no" }
        REDIS = [PSCustomObject]@{ Question = "- Download Redis ?"; Answer = "no" }
        TOOLS = [PSCustomObject]@{ Question = "- Download TOOLS (eza, delta, bat, fzf, zoxide, tldr) ?"; Answer = "no" }
        CMDER = [PSCustomObject]@{ Question = "- Download & Configure Cmder ?"; Answer = "no" }
        FONTS = [PSCustomObject]@{ Question = "- Download Nerd Fonts "; Answer = "no" }
    }

    foreach ($key in $StepsQuestions.Keys) {
        $q = $StepsQuestions[$key]
        $q.Answer = Prompt-YesOrNoWithDefault -message $q.Question -defaultOption "yes"
    }
    
    return $StepsQuestions
}
function Get-Followup-Answers {
    $StepsQuestions = [ordered]@{
        CMDER = [PSCustomObject]@{ Question = "- Did you already start cmder ? "; Answer = "no" }
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
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("")) | Out-Null
        
        return 0
    } catch {
        Write-Host "Chocolatey failed to install, try again"
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Chocolatey failed to install"
        }
        return -1
    }
}

function Set-Todo-Message {
    param ( [string]$message )
    
    $message = ($message.split("`n") | ForEach-Object { "- $($_.Trim())" }) -join "`n"

    return [PSCustomObject]@{
        Message = $message
        ForegroundColor = "Black"
        BackgroundColor = "Gray"
    }
}

function Set-Success-Message {
    param ( [string]$message )

    $message = ($message.split("`n") | ForEach-Object { "- $($_.Trim()) :)" }) -join "`n"
    
    return [PSCustomObject]@{
        Message = $message
        ForegroundColor = "Black"
        BackgroundColor = "Green"
    }
}

function Set-Error-Message {
    param ( [string]$message, $exceptionMessage = $null )

    $message = ($message.split("`n") | ForEach-Object { "- $($_.Trim()) :(" }) -join "`n"
    if ($exceptionMessage) {
        $message += "`n    --> $exceptionMessage"
    }

    return [PSCustomObject]@{
        Message = $message
        ForegroundColor = "Black"
        BackgroundColor = "Red"
    }
}

function Download-File {
    param ( [string]$url, [string]$output )
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $output
        
        return 0
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to download file from $url"
            exception = $_
        }
        return -1
    }
}

function Run-Command {
    param($command)
    
    $process = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$command`"" -Verb RunAs -WindowStyle Hidden -PassThru -Wait
    $process.WaitForExit()
    return $process.ExitCode
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
    param ( [string]$path )

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
    param ( [string]$zipPath, [string]$extractPath )
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)

        return 0
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to extract zip file from $zipPath"
            exception = $_
        }
        return -1
    }
}

function Prompt-YesOrNoWithDefault {
    param(
        [string]$message = 'Do you want to continue ? (yes/no)',
        [ValidateSet("yes", "no")]
        [string]$defaultOption = "no"
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

function Add-Env-Variable {
    param( [string]$newVariableName, [string]$newVariableValue )
    
        $output = Set-EnvVar -name $newVariableName -value $newVariableValue
        
        return $output
}

function Append-To-Env-Variable {
    param ( [string]$entry, [string]$targetVariable, [boolean]$asVarRef = 1 )
    
    $code = Update-Env-Variable -entry $entry -targetVariable $targetVariable -asVarRef $asVarRef -remove 0
    return $code
}

function Remove-From-Env-Variable {
    param ( [string]$entry, [string]$targetVariable, [boolean]$asVarRef = 1 )
    
    $code = Update-Env-Variable -entry $entry -targetVariable $targetVariable -asVarRef $asVarRef -remove 1
    return $code
}

function Update-Env-Variable {
    param( [string]$entry, [string]$targetVariable, [boolean]$asVarRef = 1, [boolean]$remove = 0 )

    $resolvedEntry = if ($asVarRef -eq 1) { "%$entry%" } else { $entry }
    $currentValue = [System.Environment]::GetEnvironmentVariable($targetVariable, [System.EnvironmentVariableTarget]::Machine)
    $entries = $currentValue -split ";" | Where-Object { $_ -ne "" }
    if ($remove -eq 1) {
        $updated = $entries | Where-Object { $_ -ne $resolvedEntry }
        if ($updated.Count -eq $entries.Count) {
            Write-Warning "Entry '$resolvedEntry' not found in $TargetVariable — nothing removed."
            return -1
        }
    } else {
        if ($resolvedEntry -in $entries) {
            Write-Warning "Entry '$entry' already exists in $TargetVariable — skipping."
            return -1
        }
        $updated = $entries + $resolvedEntry
    }
    $newValue = $updated -join ";"
    [System.Environment]::SetEnvironmentVariable($targetVariable, $newValue, [System.EnvironmentVariableTarget]::Machine)
    
    return 0
}

function Update-Path-Env-Variable {
    param( [string]$entry, [boolean]$asVarRef = 1, [boolean]$remove = 0 )
    
    $code = Update-Env-Variable -entry $entry -targetVariable "PATH" -asVarRef $asVarRef -remove $remove
    $optimized = Optimize-SystemPath
    
    return $code
}

function Print-Messages {
    param( [PSCustomObject[]]$messages = @(), [PSCustomObject[]]$todos = @() )

    if ($messages.Count -gt 0) {
        Write-Host "`n==========================================================================================`n"
        Write-Host "# Results :"
        foreach ($msg in $messages) {
            $message = $msg.Message
            Write-Host $message -ForegroundColor $msg.ForegroundColor -BackgroundColor $msg.BackgroundColor
        }
    }    
    if ($todos.Count -gt 0) {
        Write-Host "`n==========================================================================================`n"
        Write-Host "# TODOs :"
        foreach ($msg in $todos) {
            $message = $msg.Message
            Write-Host $message -ForegroundColor $msg.ForegroundColor -BackgroundColor $msg.BackgroundColor
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
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to get all environment variables"
            exception = $_
        }
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
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to get environment variable '$name'"
            exception = $_
        }
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
            return (Run-Command -command $command)
        }

        # We already have admin rights, proceed normally
        [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Machine)
        return 0
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to set environment variable '$name'"
            exception = $_
        }
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
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to optimize system PATH variable"
            exception = $_
        }
        return -1
    }
}
