
function Install-Fzf {
    try {
        $res = Ensure-PackageInstalled -name 'fzf' -chocoName 'fzf'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'FZF failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "FZF: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - FZF failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'FZF failed to install, try again!') }
    }
}
