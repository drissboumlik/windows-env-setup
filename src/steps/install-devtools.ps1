
$ProgressPreference = 'SilentlyContinue'

function Install-Git {
    try {
        Write-Host "`nDownloading and installing Git..."
        choco install git.install -y > $null 2>&1

        $message = 'Git was installed successfully'
        
        $gitConfigFile = "~/.gitconfig"
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
        $message += "`n- Git aliases are set"

        $deltaGitConfig = Get-Content "$GIT_FILES_PATH\delta-git-config.txt" -Raw
        Copy-Item -Path "$GIT_FILES_PATH\themes.gitconfig" -Destination "~/themes.gitconfig"
        Add-Content -Path $gitConfigFile -Value $deltaGitConfig

        $message += "`n- Delta was added to ~/.gitconfig successfully"
        
        return @{ code = 0; message = $message }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Git failed to install"
            exception = $_
        }
        
        return @{ code = -1; message = 'Git failed to install, try again!' }
    }
}

function Install-Nvm {
    try {
        Write-Host "`nDownloading and installing NVM..."
        choco install nvm -y > $null 2>&1
        return @{ code = 0; message = 'NVM was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - NVM failed to install"
            exception = $_
        }
        return @{ code = -1; message = 'NVM failed to install, try again!' }
    }
}

function Install-Redis {
    try {
        Write-Host "`nDownloading and installing REDIS..."
        choco install redis-64 --version=3.0.503 -y > $null 2>&1
        return @{ code = 0; message = 'REDIS was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - REDIS failed to install"
            exception = $_
        }
        return @{ code = -1; message = 'REDIS failed to install, try again!' }
    }
}

function Install-Pvm {
    param($downloadPath)

    try {
        Write-Host "`nDownloading and installing PVM..."
        git clone $PVM_URL "$downloadPath\env\tools\pvm" > $null 2>&1
        
        Update-Path-Env-Variable -variableName "$downloadPath\env\tools\pvm" -isVarName 0

        return @{ code = 0; message = 'PVM was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - PVM failed to install"
            exception = $_
        }
        return @{ code = -1; message = 'PVM failed to install, try again!' }
    }
}

function Install-Composer {
    param($downloadPath)
    
    try {
        Write-Host "`nDownloading and installing PHP for Composer..."
        Refresh-Env
        pvm setup > $null 2>&1
        pvm install latest x64 TS > $null 2>&1
        
        Write-Host "`nInstalling Composer..."
        $phpPath = Get-ChildItem "$downloadPath\env\tools\pvm\storage\php" -Directory | Select-Object -First 1 | Select-Object -ExpandProperty FullName
        Move-Item -Path "$phpPath\*" -Destination $PHP_INSTALLATION_PATH -Force
        $params = '"/Php:{0}"' -f $PHP_INSTALLATION_PATH
        choco install composer -y --params $params > $null 2>&1

        $message = 'Composer was installed successfully'
        
        $code = Install-Composer-V1
        if ($code -ne 0) {
            $message += "`nFailed to install composer version 1"
        } else {
            $message += "`nComposer version 1 was installed successfully"
        }
        
        return @{ code = 0; message = $message }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Composer failed to install"
            exception = $_
        }
        return @{ code = -1; message = 'Composer failed to install, try again' }
    }
}

function Install-Composer-V1 {
    try {
        $code = Download-File -url $COMPOSER_V1_URL -output "$COMPOSER_FILES_PATH\v1\composer.phar"
        if ($code -ne 0) {
            throw 'Failed to download v1\composer.phar file'
        }
    
        # Copy composer version 1 to the composer path
        Copy-Item -Path "$COMPOSER_FILES_PATH\v1" -Destination "$COMPOSER_INSTALLATION_PATH\v1" -Recurse
        Update-Path-Env-Variable -variableName "$COMPOSER_INSTALLATION_PATH\v1" -isVarName 0
    
        return 0
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Composer v1 failed to install"
            exception = $_
        }
        return -1
    }
}
