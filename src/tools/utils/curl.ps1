
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
