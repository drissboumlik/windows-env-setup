
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
