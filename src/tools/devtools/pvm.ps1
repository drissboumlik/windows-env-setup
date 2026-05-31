
function Install-Pvm {
    param($downloadPath)

    try {
        if (Is-Tool-Installed -name 'pvm') {
            return @{ code = 0; messages = @(Set-Success-Message -message "PVM is already installed") }
        }

        Write-Host "`nDownloading and installing PVM..."
        $pvmPath = "$downloadPath\env\tools\pvm"
        git clone $PVM_URL $pvmPath > $null 2>&1

        return @{ code = 0; messages = @(Set-Success-Message -message 'PVM was installed successfully') }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - PVM failed to install"; exception = $_ }
        return @{ code = -1; messages = @(Set-Error-Message -message 'PVM failed to install, try again!') }
    }
}
