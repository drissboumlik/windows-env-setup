
function Install-Jq {
    try {
        $res = Ensure-PackageInstalled -name 'jq' -chocoName 'jq'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'jq failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "JQ: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - jq failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'jq failed to install, try again!') }
    }
}
