
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
