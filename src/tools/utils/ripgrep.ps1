
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
