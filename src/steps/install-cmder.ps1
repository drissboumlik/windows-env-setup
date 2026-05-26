function Setup-Cmder {
    param ( $downloadPath )
    try {
        Write-Host "`nDownloading & Extracting Cmder..."
        $code = Download-File -url $CMDER_URL -output "$downloadPath\Cmder.zip"
        if ($code -ne 0) {
            throw "Failed to download Cmder"
        }

        $code = Extract-Zip -zipPath "$downloadPath\Cmder.zip" -extractPath "$downloadPath\Cmder"
        if ($code -ne 0) {
            throw "Failed to extract Cmder"
        }
        Remove-Item "$downloadPath\Cmder.zip"

        $cmderStuff = @(
            "$downloadPath\Cmder\vendor\git-for-windows\usr\bin",
            "$downloadPath\Cmder\vendor\git-for-windows\bin",
            "$downloadPath\Cmder\vendor\bin",
            "$downloadPath\Cmder\vendor",
            "$downloadPath\Cmder\bin",
            "$downloadPath\Cmder"
        )

        $errors = @()
        $cmderStuff | ForEach-Object {
            $code = Append-To-Env-Variable -entry $_ -targetVariable $DEV_TOOLS_ENV_VAR -asVarRef 0
            if ($code -ne 0) {
                $errors += "Failed to add '$_' to the PATH variable"
            }
        }
        
        $message = @(Set-Success-Message -message 'Cmder was installed successfully')
        
        if ($errors.Count -ne 0) {
            $message += @(Set-Error-Message -message "Cmder was installed but with some issues : `n" + ($errors -join "`n"))
        } else {
            $message += @(Set-Success-Message -message "Cmder paths were added to the PATH variable")
        }

        return @{ code = 0; messages = $message }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - CMDER failed to install"
            exception = $_
        }
        
        return @{ code = -1; messages = @(Set-Error-Message -message 'CMDER failed to install, Try again!') }
    }
}

function Install-Flexprompt {
    try {
        Write-Host "`nDownloading & Extracting FlexPrompt..."
        git clone $CLINK_FLEX_PROMPT_URL "$downloadPath\clink-flex-prompt" > $null 2>&1
        Move-Item -Path "$downloadPath\clink-flex-prompt\*" -Destination "$downloadPath\Cmder\config"

        Copy-Item -Path "$CMDER_FILES_PATH\flexprompt_autoconfig.lua" -Destination "$downloadPath\Cmder\config"
        Remove-Item -Path "$downloadPath\clink-flex-prompt" -Recurse -Force
        
        return @{
            code = 0;
            messages = @(Set-Success-Message -message "Flexprompt installed successfully");
            todos = @(Set-Todo-Message -message "Start cmder and Run 'flexprompt configure' to customize the prompt style.")
        }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - FlexPrompt failed to install"
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'Flexprompt failed to install, try installing it manually!') }
    }
}

function Install-Cmder {
    param ($downloadPath)

    try {
        $result = Setup-Cmder -downloadPath $downloadPath
        
        if ($result.code -ne 0) {
            return $result
        }
        
        $result.todos += Set-Todo-Message -message "Start cmder and Run 'clink update' to check for any updates"
        
        $flexpromptInstaller = Install-Flexprompt
        $result.messages += $flexpromptInstaller.messages
        $result.todos += $flexpromptInstaller.todos
        
        $cmderCustomized = Customize-Cmder -downloadPath $downloadPath
        $result.messages += $cmderCustomized.messages

        return $result
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Issue with installing cmder"
            exception = $_
        }
        
        return @{ code = -1; messages = @(Set-Error-Message -message 'Issue with installing cmder, try again!') }
    }
}

function Customize-Cmder {
    param ($downloadPath)
    
    try {
        if (Test-Path "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml") {
            Copy-Item -Path "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml" -Destination "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml.bak"
        } else {
            Write-Warning "No ConEmu.xml found to backup."
        }
        Copy-Item -Path "$CMDER_FILES_PATH\ConEmu.xml" -Destination "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml"
        
        Copy-Item -Path "$CMDER_FILES_PATH\zoxide.lua" -Destination "$downloadPath\Cmder\config\zoxide.lua"
        
        if (Test-Path "$downloadPath\Cmder\config\user_aliases.cmd") {
            Copy-Item -Path "$downloadPath\Cmder\config\user_aliases.cmd" -Destination "$downloadPath\Cmder\config\user_aliases.cmd.bak"
        } else {
            Write-Warning "No user_aliases.cmd found to backup."
        }
        Get-Content -Path "$CMDER_FILES_PATH\user_aliases.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_aliases.cmd"
    
        if (Test-Path "$downloadPath\Cmder\config\user_profile.cmd") {
            Copy-Item -Path "$downloadPath\Cmder\config\user_profile.cmd" -Destination "$downloadPath\Cmder\config\user_profile.cmd.bak"
        } else {
            Write-Warning "No user_profile.cmd found to backup."
        }
        
        Get-Content -Path "$CMDER_FILES_PATH\user_profile.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_profile.cmd"
    
        return @{ code = 0; messages = @(Set-Success-Message -message 'ConEmu.xml user_profile.cmd & user_aliases.cmd were added to Cmder successfully') }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to add ConEmu.xml user_profile.cmd & user_aliases.cmd to Cmder"
            exception = $_
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'Failed to add ConEmu.xml user_profile.cmd & user_aliases.cmd to Cmder') }
    }
}

function Configure-Cmder {
    param ($downloadPath)

    try {
        $backupFile = "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml.bak"
        if (-not (Test-Path $backupFile)) {
            Copy-Item -Path "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml" -Destination $backupFile
        }
        Copy-Item -Path "$CMDER_FILES_PATH\ConEmu.xml" -Destination "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml"
        
        Copy-Item -Path "$CMDER_FILES_PATH\zoxide.lua" -Destination "$downloadPath\Cmder\config\zoxide.lua"
        
        $backupFile = "$downloadPath\Cmder\config\user_aliases.cmd.bak"
        if (Test-Path $backupFile) {
            Copy-Item -Path $backupFile -Destination "$downloadPath\Cmder\config\user_aliases.cmd"
        } else {
            Copy-Item -Path "$downloadPath\Cmder\config\user_aliases.cmd" -Destination $backupFile
        }
        Get-Content -Path "$CMDER_FILES_PATH\user_aliases.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_aliases.cmd"
    
        $backupFile = "$downloadPath\Cmder\config\user_profile.cmd.bak"
        if (Test-Path $backupFile) {
            Copy-Item -Path $backupFile -Destination "$downloadPath\Cmder\config\user_profile.cmd"
        } else {
            Copy-Item -Path "$downloadPath\Cmder\config\user_profile.cmd" -Destination $backupFile
        }
        Get-Content -Path "$CMDER_FILES_PATH\user_profile.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_profile.cmd"
    
        $message = 'Cmder configured successfully'
        $message += "`nConEmu.xml & user_aliases.cmd were added to Cmder successfully";
        $messages = @(Set-Success-Message -message $message)
        
        return @{ code = 0; messages = $messages }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to configure Cmder"
            exception = $_
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'Failed to configure Cmder, try again!') }
    }
}
