
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
