
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
