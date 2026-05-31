
function Install-Nvm {
    try {
        $res = Ensure-PackageInstalled -name 'nvm' -chocoName 'nvm'

        if ($res.code -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message 'NVM failed to install') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message "NVM: $($res.message)") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - NVM failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'NVM failed to install, try again!') }
    }
}
