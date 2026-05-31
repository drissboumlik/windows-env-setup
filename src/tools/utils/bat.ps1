
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
