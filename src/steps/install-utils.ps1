
function Install-Eza {
    try {
        Write-Host "`nInstalling EZA (better ls)..."
        $res = Ensure-PackageInstalled -exeName eza -chocoName eza

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'EZA failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "EZA: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - EZA failed to install"
            exception = $_
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'EZA failed to install, try again!') }
    }
}

function Install-Delta {
    try {
        Write-Host "`nInstalling DELTA (better git diff)..."
        $res = Ensure-PackageInstalled -exeName delta -chocoName delta

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'DELTA failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "DELTA: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - DELTA failed to install"
            exception = $_
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'DELTA failed to install, try again!') }
    }
}

function Install-Bat {
    try {
        Write-Host "`nInstalling BAT (better cat)..."
        $res = Ensure-PackageInstalled -exeName bat -chocoName bat

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'BAT failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "BAT: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - BAT failed to install"
            exception = $_
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'BAT failed to install, try again!') }
    }
}

function Install-Fzf {
    try {
        Write-Host "`nInstalling FZF (Fuzzy finder)..."
        $res = Ensure-PackageInstalled -exeName fzf -chocoName fzf

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'FZF failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "FZF: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - FZF failed to install"
            exception = $_
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'FZF failed to install, try again!') }
    }
}

function Install-Zoxide {
    try {
        Write-Host "`nInstalling ZOXIDE/Z (better cd)..."
        $res = Ensure-PackageInstalled -exeName zoxide -chocoName zoxide

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'ZOXIDE failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "ZOXIDE: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - ZOXIDE failed to install"
            exception = $_
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'ZOXIDE failed to install, try again!') }
    }
}

function Install-Tldr {
    try {
        Write-Host "`nInstalling TLDR (simplified man pages)..."
        $res = Ensure-PackageInstalled -exeName tldr -chocoName tldr

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'TLDR failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "TLDR: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - TLDR failed to install"
            exception = $_
        }
        return @{ code = -1; messages = @(Set-Error-Message -message 'TLDR failed to install, try again!') }
    }
}
