
function Install-Chocolatey {
    try {
        if (Is-Tool-Installed -name 'choco') {
            return @{ code = 0; messages = @( Set-Success-Message -message 'Chocolatey is already installed' ) }
        }

        Write-Host "`nDownloading and installing Chocolatey..."

        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("")) | Out-Null

        return @{ code = 0; messages = @(Set-Success-Message -message "Chocolatey installed successfully") }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - Chocolatey failed to install"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message "Chocolatey failed or is already installed, try again") }
    }
}
