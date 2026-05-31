
function Install-Composer {
    param($downloadPath)

    try {
        if (Is-Tool-Installed -name 'composer') {
            return @{ code = 0; messages = @(Set-Success-Message -message 'Composer is already installed') }
        }

        Write-Host "`nDownloading and installing PHP for Composer..."
        & "$downloadPath\env\tools\pvm\pvm.bat" setup > $null 2>&1
        & "$downloadPath\env\tools\pvm\pvm.bat" install latest x64 TS > $null 2>&1

        Write-Host "`nInstalling Composer..."
        $phpPath = Get-ChildItem "$downloadPath\env\tools\pvm\storage\php" -Directory | Select-Object -First 1 | Select-Object -ExpandProperty FullName
        Move-Item -Path "$phpPath\*" -Destination $PHP_INSTALLATION_PATH -Force
        $params = '"/Php:{0}"' -f $PHP_INSTALLATION_PATH
        if (-not (Is-Admin)) {
            $code = Run-Command -filePath 'choco' -arguments @('install', 'composer', '-y', '--params', $params)
        } else {
            choco install composer -y --params $params > $null 2>&1
        }

        if (Is-Tool-Not-Installed -name 'composer') {
            $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to install Composer"; exception = $null }
            return @{ code = -1; messages = @(Set-Error-Message -message 'Failed to install Composer') }
        }

        $messages = @(Set-Success-Message -message 'Composer was installed successfully')

        $result = Install-Composer-V1
        $messages += $result.messages

        return @{ code = 0; messages = $messages }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Composer failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'Composer failed to install, try again') }
    }
}

function Install-Composer-V1 {
    try {
        $composerV1Path = "$COMPOSER_INSTALLATION_PATH\v1"

        if ((Is-Tool-Installed -name 'composer1') -and (Test-Path "$composerV1Path\composer.phar")) {
            return @{ code = 0; messages = @(Set-Success-Message -message "Composer v1 is already installed at '$composerV1Path'") }
        }

        $code = Download-File -url $COMPOSER_V1_URL -output "$COMPOSER_FILES_PATH\v1\composer.phar"
        if ($code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'Failed to download v1\composer.phar file') }
        }

        # Copy composer version 1 to the composer path
        Copy-Item -Path "$COMPOSER_FILES_PATH\v1" -Destination $composerV1Path -Recurse
        $messages = @(Set-Success-Message -message 'Composer v1 was installed successfully')

        $updated = Append-To-Env-Variable -entry $composerV1Path -targetVariable $DEV_TOOLS_ENV_VAR -asVarRef 0
        if ($updated.code -eq 0) {
            $messages += Set-Success-Message -message "Updated '$DEV_TOOLS_ENV_VAR' environment variable with '$composerV1Path'"
        } else {
            $messages += Set-Error-Message -message "Failed to update '$DEV_TOOLS_ENV_VAR' environment variable with '$composerV1Path'"
        }

        return @{ code = 0; messages = $messages }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Composer v1 failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'Composer v1 failed to install, try again') }
    }
}
