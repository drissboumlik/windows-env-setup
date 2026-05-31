
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

        $res = Configure-Git -gitConfigFile $gitConfigFile
        $messages += $res.messages

        return @{ code = 0; messages = $messages }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Git failed to install"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message 'Git failed to install, try again!') }
    }
}

function Configure-Git {
    param ($gitConfigFile)

    try {
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
        $messages = Set-Success-Message -message 'Git aliases are set'

        $deltaGitConfig = Get-Content "$GIT_FILES_PATH\delta-git-config.txt" -Raw
        Copy-Item -Path "$GIT_FILES_PATH\themes.gitconfig" -Destination "~/themes.gitconfig"
        Add-Content -Path $gitConfigFile -Value $deltaGitConfig | Out-Null

        $messages += Set-Success-Message -message 'Delta was added to ~/.gitconfig successfully'

        return @{ code = 0; messages = $messages }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Failed to configure Git"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'Failed to configure Git, try again!') }
    }
}
