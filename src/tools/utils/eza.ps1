
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
