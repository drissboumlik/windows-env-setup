
function Install-Tree {
    try {
        $res = Ensure-PackageInstalled -name 'tree' -chocoName 'tree'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'tree failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "TREE: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - tree failed"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'tree failed to install, try again!') }
    }
}
