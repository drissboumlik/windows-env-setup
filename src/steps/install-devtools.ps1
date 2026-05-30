
function Install-Git {
    try {
        $res = Ensure-PackageInstalled -name 'git' -chocoName 'git.install'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'Git failed to install') }
        }
        
        $gitConfigFile = "$HOME/.gitconfig"
        $isGitInstalled = ($res.code -eq 0)
        $configHasLogPretty = $false
        $configHasDelta = $false

        if ($isGitInstalled -and (Test-Path $gitConfigFile)) {
            $gitConfig = Get-Content $gitConfigFile -Raw -ErrorAction SilentlyContinue
            if ($gitConfig -match 'log-pretty\s*=') { $configHasLogPretty = $true }
            if ($gitConfig -match 'themes\.gitconfig|^\s*\[delta\]' -and $gitConfig -match 'pager\s*=\s*delta') { $configHasDelta = $true }
        }

        if ($isGitInstalled -and $configHasLogPretty -and $configHasDelta) {
            return @{ code = 0; messages = @(Set-Success-Message -message 'Git is already installed and configured') }
        }

        $messages = @(Set-Success-Message -message 'Git was installed successfully')

        if (-not (Test-Path $gitConfigFile)) {
            New-Item -Path $gitConfigFile -ItemType "File"
        }

        $backupFile = "~/.gitconfig.bak"
        if (Test-Path $backupFile) {
            Copy-Item -Path $backupFile -Destination $gitConfigFile
        } else {
            Copy-Item -Path $gitConfigFile -Destination $backupFile
        }

        git config --global alias.alias "! git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /"
        git config --global alias.log-pretty  "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.log-pretty2 "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cgreen(%cs) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.log-pretty3 "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cgreen(%ch) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.nah "!f(){ git reset --hard; git clean -df; if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then git rebase --abort; fi; }; f"
        $messages += Set-Success-Message -message 'Git aliases are set'

        $deltaGitConfig = Get-Content "$GIT_FILES_PATH\delta-git-config.txt" -Raw
        Copy-Item -Path "$GIT_FILES_PATH\themes.gitconfig" -Destination "~/themes.gitconfig"
        Add-Content -Path $gitConfigFile -Value $deltaGitConfig | Out-Null

        $messages += Set-Success-Message -message 'Delta was added to ~/.gitconfig successfully'

        return @{ code = 0; messages = $messages }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Git failed to install"; exception = $_ }

        $message = Set-Error-Message -message 'Git failed to install, try again!'
        return @{ code = -1; messages = @(Set-Error-Message -message 'Git failed to install, try again!') }
    }
}

function Install-Nvm {
    try {
        $res = Ensure-PackageInstalled -name 'nvm' -chocoName 'nvm'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'NVM failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "NVM: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - NVM failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'NVM failed to install, try again!') }
    }
}

function Install-Redis {
    try {
        if ((Is-Tool-Installed -name 'redis-server') -or (Is-Tool-Installed -name 'redis-cli')) {
            return @{ code = 0; messages = @(Set-Success-Message -message 'REDIS is already installed') }
        }

        Write-Host "`nDownloading and installing REDIS..."
        
        if (-not (Is-Admin)) {
            $code = Run-Command -filePath 'choco' -arguments @('install', 'redis-64', '--version=3.0.503' , '-y')
        } else {
            choco install redis-64 --version=3.0.503 -y > $null 2>&1
        }

        if ((Is-Tool-Not-Installed -name 'redis-server') -and (Is-Tool-Not-Installed -name 'redis-cli')) {
            $logged = Log-Data -data @{ header = 'Install-Redis - Failed to install REDIS'; exception = $null }
            return @{ code = -1; messages = @(Set-Error-Message -message 'REDIS failed to install, try again!') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message 'REDIS was installed successfully') }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - REDIS failed to install"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message 'REDIS failed to install, try again!') }
    }
}

function Install-Pvm {
    param($downloadPath)

    try {
        if (Is-Tool-Installed -name 'pvm') {
            return @{ code = 0; messages = @(Set-Success-Message -message "PVM is already installed") }
        }

        Write-Host "`nDownloading and installing PVM..."
        $pvmPath = "$downloadPath\env\tools\pvm"
        git clone $PVM_URL $pvmPath > $null 2>&1

        return @{ code = 0; messages = @(Set-Success-Message -message 'PVM was installed successfully') }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - PVM failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'PVM failed to install, try again!') }
    }
}

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
            $logged = Log-Data -data @{ header = 'Install-Composer - Failed to install Composer'; exception = $null }
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
