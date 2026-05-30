
function Install-UserScripts {
    param ($downloadPath)

    try {
        $scriptsCommandsPath = "$downloadPath\scripts\src\commands"

        if (Test-Path $scriptsCommandsPath) {
            return @{ code = 0; messages = @(Set-Success-Message -message 'User scripts are already installed') }
        }

        git clone $USER_SCRIPTS_URL "$downloadPath\scripts" > $null 2>&1

        $toolsPath = "$downloadPath\tools\bin"
        $created = Make-Directory -path $toolsPath
        if ($created -ne 0) {
            throw "Failed to create tools/bin directory at $toolsPath"
        }

        $messages = @()

        $updated = Append-To-Env-Variable -entry $toolsPath -targetVariable $DEV_TOOLS_ENV_VAR -asVarRef 0
        if ($updated -ne 0) {
            $messages += Set-Error-Message -message "Failed to update '$DEV_TOOLS_ENV_VAR' environment variable with '$toolsPath'"
        }

        $errors = @()
        Get-ChildItem "$scriptsCommandsPath\*" -Directory | ForEach-Object {
            Get-ChildItem "$($_.FullName)\*.ps1" | ForEach-Object {
                try {
                    $batFilePath = "$toolsPath\$($_.BaseName).bat"
                    $batContent = Get-Content "$USER_SCRIPTS_FILES_PATH\skeleton.bat" -Raw
                    $batContent = $batContent -replace '__FILE_TARGET__', $_.FullName
                    Set-Content -Path $batFilePath -Value $batContent | Out-Null
                } catch {
                    $errors += @(Set-Error-Message -message "Failed to create .bat file for '$($_.Name)' command")
                }
            } | Out-Null
        } | Out-Null

        if ($errors.Count -eq 0) {
            $messages += Set-Success-Message -message 'User scripts were installed successfully'
        } else {
            $messages += Set-Error-Message -message "User scripts were installed with some issues : `n" + ($errors -join "`n")
        }

        return @{ code = 0; messages = $messages }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to clone user scripts repository"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message 'Failed to clone user scripts repository, try again!') }
    }
}
