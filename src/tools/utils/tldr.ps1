
function Install-Tldr {
    try {
        $res = Ensure-PackageInstalled -name 'tldr' -chocoName 'tldr'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'TLDR failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "TLDR: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - TLDR failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'TLDR failed to install, try again!') }
    }
}
