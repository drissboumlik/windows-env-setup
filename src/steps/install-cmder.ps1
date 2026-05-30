function Setup-Cmder {
    param ( $downloadPath )
    try {
        $cmderPath = "$downloadPath\$CMDER_INSTALLATION_DIRECTORY_NAME"

        if ((Is-Tool-Installed -name 'cmder') -or (Is-Tool-Installed -name "$cmderPath\cmder")) {
            return @{ code = -1; messages = @(Set-Success-Message -message "Cmder is already installed") }
        }

        Write-Host "`nDownloading & Extracting Cmder..."

        $code = Download-File -url $CMDER_URL -output "$downloadPath\Cmder.zip"
        if ($code -ne 0) {
            throw "Failed to download Cmder"
        }

        $code = Extract-Zip -zipPath "$downloadPath\Cmder.zip" -extractPath $cmderPath
        if ($code -ne 0) {
            throw "Failed to extract Cmder"
        }
        Remove-Item -Path "$downloadPath\Cmder.zip"

        $cmderStuff = @(
            "$cmderPath\vendor\git-for-windows\usr\bin",
            "$cmderPath\vendor\git-for-windows\bin",
            "$cmderPath\vendor\bin",
            "$cmderPath\vendor",
            "$cmderPath\bin",
            "$cmderPath"
        )

        $errors = @()
        $cmderStuff | ForEach-Object {
            $res = Append-To-Env-Variable -entry $_ -targetVariable $DEV_TOOLS_ENV_VAR -asVarRef 0
            if ($res.code -ne 0) {
                $errors += "Failed to add '$_' to the PATH variable"
            }
        }

        $messages = @(Set-Success-Message -message 'Cmder was installed successfully')

        if ($errors.Count -ne 0) {
            $messages += @(Set-Error-Message -message "Cmder was installed but with some issues : `n" + ($errors -join "`n"))
        } else {
            $messages += @(Set-Success-Message -message 'Cmder paths were added to the PATH variable')
        }

        return @{ code = 0; messages = $messages; path = $cmderPath }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - CMDER failed to install"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message 'CMDER failed to install, Try again!') }
    }
}

function Install-Flexprompt {
    param ($downloadPath, $cmderPath)

    try {
        Write-Host "`nDownloading & Extracting FlexPrompt..."
        git clone $CLINK_FLEX_PROMPT_URL "$downloadPath\clink-flex-prompt" > $null 2>&1
        Move-Item -Path "$downloadPath\clink-flex-prompt\*" -Destination "$cmderPath\config" -Force
        Remove-Item -Path "$downloadPath\clink-flex-prompt" -Recurse -Force

        Copy-Item -Path "$CMDER_FILES_PATH\flexprompt_autoconfig.lua" -Destination "$cmderPath\config"

        return @{
            code = 0;
            messages = @(Set-Success-Message -message "Flexprompt installed successfully");
            todos = @(Set-Todo-Message -message "Start cmder and Run 'flexprompt configure' to customize the prompt style.")
        }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - FlexPrompt failed to install"; exception = $_ }
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

        if (-not $result.ContainsKey('todos')) {
            $result['todos'] = @()
        }

        $result.todos += Set-Todo-Message -message "Start cmder and Run 'clink update' to check for any updates"

        $flexpromptInstaller = Install-Flexprompt -downloadPath $downloadPath -cmderPath $result.path
        $result.messages += $flexpromptInstaller.messages
        if ($flexpromptInstaller.todos) {
            $result.todos += $flexpromptInstaller.todos
        }

        $cmderCustomized = Customize-Cmder -cmderPath $result.path
        $result.messages += $cmderCustomized.messages

        return $result
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Issue with installing cmder"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message 'Issue with installing cmder, try again!') }
    }
}

function Customize-Cmder {
    param ($cmderPath)

    try {
        if (Test-Path "$cmderPath\vendor\conemu-maximus5\ConEmu.xml") {
            Copy-Item -Path "$cmderPath\vendor\conemu-maximus5\ConEmu.xml" -Destination "$cmderPath\vendor\conemu-maximus5\ConEmu.xml.bak"
        } else {
            Write-Warning "No ConEmu.xml found to backup."
        }
        Copy-Item -Path "$CMDER_FILES_PATH\ConEmu.xml" -Destination "$cmderPath\vendor\conemu-maximus5\ConEmu.xml"

        Copy-Item -Path "$CMDER_FILES_PATH\zoxide.lua" -Destination "$cmderPath\config\zoxide.lua"

        if (Test-Path "$cmderPath\config\user_aliases.cmd") {
            Copy-Item -Path "$cmderPath\config\user_aliases.cmd" -Destination "$cmderPath\config\user_aliases.cmd.bak"
        } else {
            Write-Warning "No user_aliases.cmd found to backup."
        }
        Get-Content -Path "$CMDER_FILES_PATH\user_aliases.cmd" | Add-Content -Path "$cmderPath\config\user_aliases.cmd"

        if (Test-Path "$cmderPath\config\user_profile.cmd") {
            Copy-Item -Path "$cmderPath\config\user_profile.cmd" -Destination "$cmderPath\config\user_profile.cmd.bak"
        } else {
            Write-Warning "No user_profile.cmd found to backup."
        }

        Get-Content -Path "$CMDER_FILES_PATH\user_profile.cmd" | Add-Content -Path "$cmderPath\config\user_profile.cmd"

        return @{ code = 0; messages = @(Set-Success-Message -message 'ConEmu.xml user_profile.cmd & user_aliases.cmd were added to Cmder successfully') }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to add ConEmu.xml user_profile.cmd & user_aliases.cmd to Cmder"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'Failed to add ConEmu.xml user_profile.cmd & user_aliases.cmd to Cmder') }
    }
}

function Configure-Cmder {
    param ($cmderPath)

    try {
        Restore-Or-BackupFile -filePath "$cmderPath\vendor\conemu-maximus5\ConEmu.xml"
        Copy-Item -Path "$CMDER_FILES_PATH\ConEmu.xml" -Destination "$cmderPath\vendor\conemu-maximus5\ConEmu.xml"

        Copy-Item -Path "$CMDER_FILES_PATH\zoxide.lua" -Destination "$cmderPath\config\zoxide.lua"

        Restore-Or-BackupFile -filePath "$cmderPath\config\user_aliases.cmd"
        Get-Content -Path "$CMDER_FILES_PATH\user_aliases.cmd" | Add-Content -Path "$cmderPath\config\user_aliases.cmd"

        Restore-Or-BackupFile -filePath "$cmderPath\config\user_profile.cmd"
        Get-Content -Path "$CMDER_FILES_PATH\user_profile.cmd" | Add-Content -Path "$cmderPath\config\user_profile.cmd"

        $message = 'Cmder configured successfully'
        $message += "`nConEmu.xml, user_aliases.cmd, user_profile.cmd & zoxide were added to Cmder successfully";

        return @{ code = 0; messages = @(Set-Success-Message -message $message) }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to configure Cmder"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'Failed to configure Cmder, try again!') }
    }
}
