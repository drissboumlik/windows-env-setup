
function Install-Fonts {
    param ($downloadPath)
    try {
        if (Test-Path -Path "$downloadPath\fonts") {
            return @{ code = 0; messages = @(Set-Success-Message -message "Fonts are already installed") }
        }

        Write-Host "`nDownloading Fonts..."
        $nfUrls = Get-Content "$SETUP_ROOT\files\fonts\links.txt" | Where-Object { $_ -ne "" }
        $created = Make-Directory -path "$downloadPath\fonts"
        if ($created -ne 0) {
            throw "Failed to create fonts directory at '$downloadPath\fonts'"
        }

        $errors = @()
        foreach ($url in $nfUrls) {
            $fileName = Split-Path $url -Leaf
            $code = Download-File -url $url -output "$downloadPath\fonts\$fileName"
            if ($code -ne 0) {
                $errors += "Failed to download font from '$url'"
            }
        }

        if ($errors.Count -eq 0) {
            $messages = Set-Success-Message -message 'Fonts downloaded successfully'
        } else {
            $messages = Set-Error-Message -message ("Fonts downloaded with some issues : `n" + ($errors -join "`n"))
        }

        return @{ code = 0; messages = $messages; todos = @( Set-Todo-Message -message "Install downloaded font and Add it to cmder settings." ) }
    } catch {
        $logged = Log-Data -data @{header = "$($MyInvocation.MyCommand.Name) - Fonts failed to download"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message 'Fonts failed to download, try again!') }
    }
}
