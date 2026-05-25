
function Install-Eza {
    try {
        Write-Host "`nInstalling EZA (better ls)..."
        choco install eza -y > $null 2>&1
        
        return @{ code = 0; messages = 'EZA was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - EZA failed to install"
            exception = $_
        }
        return @{ code = -1; messages = 'EZA failed to install, try again!' }
    }
}

function Install-Delta {
    try {
        Write-Host "`nInstalling DELTA (better git diff)..."
        choco install delta -y > $null 2>&1;
        
        return @{ code = 0; messages = 'DELTA was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - DELTA failed to install"
            exception = $_
        }
        return @{ code = -1; messages = 'DELTA failed to install, try again!' }
    }
}

function Install-Bat {
    try {
        Write-Host "`nInstalling BAT (better cat)..."
        choco install bat -y > $null 2>&1
        
        return @{ code = 0; messages = 'BAT was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - BAT failed to install"
            exception = $_
        }
        return @{ code = -1; messages = 'BAT failed to install, try again!' }
    }
}

function Install-Fzf {
    try {
        Write-Host "`nInstalling FZF (Fuzzy finder)..."
        choco install fzf -y > $null 2>&1

        return @{ code = 0; messages = 'FZF was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - FZF failed to install"
            exception = $_
        }
        return @{ code = -1; messages = 'FZF failed to install, try again!' }
    }
}

function Install-Zoxide {
    try {
        Write-Host "`nInstalling ZOXIDE/Z (better cd)..."
        choco install zoxide -y > $null 2>&1

        return @{ code = 0; messages = 'ZOXIDE was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - ZOXIDE failed to install"
            exception = $_
        }
        return @{ code = -1; messages = 'ZOXIDE failed to install, try again!' }
    }
}

function Install-Tldr {
    try {
        Write-Host "`nInstalling TLDR (simplified man pages)..."
        choco install tldr -y > $null 2>&1

        return @{ code = 0; messages = 'TLDR was installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - TLDR failed to install"
            exception = $_
        }
        return @{ code = -1; messages = 'TLDR failed to install, try again!' }
    }
}
