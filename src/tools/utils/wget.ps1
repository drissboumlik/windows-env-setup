
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
