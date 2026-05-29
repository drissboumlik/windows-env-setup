
function Install-Eza {
    try {
        Write-Host "`nInstalling EZA (better ls)..."
        $res = Ensure-PackageInstalled -exeName eza -chocoName eza

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'EZA failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "EZA: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - EZA failed to install"; exception = $_ }
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
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - DELTA failed to install"; exception = $_ }
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
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - BAT failed to install"; exception = $_ }
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
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - FZF failed to install"; exception = $_ }
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
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - ZOXIDE failed to install"; exception = $_ }
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
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - TLDR failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'TLDR failed to install, try again!') }
    }
}

function Install-Fd {
    try {
        Write-Host "`nInstalling FD (faster find)..."
        $res = Ensure-PackageInstalled -exeName fd -chocoName fd
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'fd failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "fd: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - fd failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'fd failed to install, try again!') }
    }
}

function Install-Ripgrep {
    try {
        Write-Host "`nInstalling RIPGREP (faster grep)..."
        $res = Ensure-PackageInstalled -exeName rg -chocoName ripgrep

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'ripgrep failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "ripgrep: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - ripgrep failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'ripgrep failed to install, try again!') }
    }
}

function Install-Starship {
    try {
        Write-Host "`nInstalling STARSHIP (cross-shell prompt)..."
        $res = Ensure-PackageInstalled -exeName starship -chocoName starship

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'starship failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "starship: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - starship failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'starship failed to install, try again!') }
    }
}

function Install-Jq {
    try {
        Write-Host "`nInstalling JQ (JSON processor)..."
        $res = Ensure-PackageInstalled -exeName jq -chocoName jq

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'jq failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "jq: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - jq failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'jq failed to install, try again!') }
    }
}

function Install-Yq {
    try {
        Write-Host "`nInstalling YQ (YAML processor)..."
        $res = Ensure-PackageInstalled -exeName yq -chocoName yq
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'yq failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "yq: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - yq failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'yq failed to install, try again!') }
    }
}

function Install-Tree {
    try {
        Write-Host "`nInstalling TREE..."
        $res = Ensure-PackageInstalled -exeName tree -chocoName tree
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'tree failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "tree: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - tree failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'tree failed to install, try again!') }
    }
}

function Install-Curl {
    try {
        Write-Host "`nInstalling CURL..."
        $res = Ensure-PackageInstalled -exeName curl -chocoName curl
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'curl failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "curl: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - curl failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'curl failed to install, try again!') }
    }
}

function Install-Wget {
    try {
        Write-Host "`nInstalling WGET..."
        $res = Ensure-PackageInstalled -exeName wget -chocoName wget
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'wget failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "wget: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - wget failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'wget failed to install, try again!') }
    }
}
