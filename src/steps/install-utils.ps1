
function Install-Eza {
    try {
        $res = Ensure-PackageInstalled -name 'eza' -chocoName 'eza'

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
        $res = Ensure-PackageInstalled -name 'delta' -chocoName 'delta'

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
        $res = Ensure-PackageInstalled -name 'bat' -chocoName 'bat'

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
        $res = Ensure-PackageInstalled -name 'fzf' -chocoName 'fzf'

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
        $res = Ensure-PackageInstalled -name 'zoxide' -chocoName 'zoxide'

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
        $res = Ensure-PackageInstalled -name 'tldr' -chocoName 'tldr'

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
        $res = Ensure-PackageInstalled -name 'fd' -chocoName 'fd'
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'fd failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "FD: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - fd failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'fd failed to install, try again!') }
    }
}

function Install-Ripgrep {
    try {
        $res = Ensure-PackageInstalled -name 'rg' -chocoName 'ripgrep'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'ripgrep failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "RIPGREP: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - ripgrep failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'ripgrep failed to install, try again!') }
    }
}

function Install-Starship {
    try {
        $res = Ensure-PackageInstalled -name 'starship' -chocoName 'starship'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'starship failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "STARSHIP: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - starship failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'starship failed to install, try again!') }
    }
}

function Install-Jq {
    try {
        $res = Ensure-PackageInstalled -name 'jq' -chocoName 'jq'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'jq failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "JQ: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - jq failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'jq failed to install, try again!') }
    }
}

function Install-Yq {
    try {
        $res = Ensure-PackageInstalled -name 'yq' -chocoName 'yq'
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'yq failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "YQ: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - yq failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'yq failed to install, try again!') }
    }
}

function Install-Tree {
    try {
        $res = Ensure-PackageInstalled -name 'tree' -chocoName 'tree'
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'tree failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "TREE: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - tree failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'tree failed to install, try again!') }
    }
}

function Install-Curl {
    try {
        $res = Ensure-PackageInstalled -name 'curl' -chocoName 'curl'
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'curl failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "CURL: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - curl failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'curl failed to install, try again!') }
    }
}

function Install-Wget {
    try {
        $res = Ensure-PackageInstalled -name 'wget' -chocoName 'wget'
        
        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'wget failed to install') }
        }
        
        return @{ code = 0; messages = @(Set-Success-Message -message "WGET: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - wget failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'wget failed to install, try again!') }
    }
}
