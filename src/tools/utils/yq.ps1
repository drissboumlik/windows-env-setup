
function Install-Yq {
    try {
        $res = Ensure-PackageInstalled -name 'yq' -chocoName 'yq'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'yq failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "YQ: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - yq failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'yq failed to install, try again!') }
    }
}
