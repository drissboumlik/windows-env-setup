
function Install-Redis {
    try {
        if ((Is-Tool-Installed -name 'redis-server') -or (Is-Tool-Installed -name 'redis-cli')) {
            return @{ code = 0; messages = @(Set-Success-Message -message 'REDIS is already installed') }
        }

        Write-Host "`nDownloading and installing REDIS..."

        if (-not (Is-Admin)) {
            $code = Run-Command -filePath 'choco' -arguments @('install', 'redis-64', '--version=3.0.503' , '-y')
        } else {
            choco install redis-64 --version=3.0.503 -y > $null 2>&1
        }

        if ((Is-Tool-Not-Installed -name 'redis-server') -and (Is-Tool-Not-Installed -name 'redis-cli')) {
            $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - REDIS failed to install"; exception = $null }
            return @{ code = -1; messages = @(Set-Error-Message -message 'REDIS failed to install, try again!') }
        }

        return @{ code = 0; messages = @(Set-Success-Message -message 'REDIS was installed successfully') }
    } catch {
        $logged = Log-Data -data @{ header = "$($MyInvocation.MyCommand.Name) - REDIS failed to install"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message 'REDIS failed to install, try again!') }
    }
}
