
function Install-Fonts {
    param ($downloadPath)
    try {
        Write-Host "`nDownloading Font..."
        $nfUrls = Get-Content "$SETUP_ROOT\files\fonts.txt" | Where-Object { $_ -ne "" }
        Make-Directory -path "$downloadPath\fonts"
        
        $errors = @()
        foreach ($url in $nfUrls) {
            $fileName = Split-Path $url -Leaf
            try { Download-File -url $url -output "$downloadPath\fonts\$fileName" }
            catch { $errors += "Fonts : Issue with $fileName" }
        }
        
        if ($errors.Count -eq 0) {
            $message = 'Fonts downloaded successfully'
        } else {
            $message = "Fonts downloaded with some issues : `n" + ($errors -join "`n")
        }
        
        return @{ code = 0; message = $message; todo = "Install downloaded font and Add it to cmder settings." }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Fonts failed to download"
            exception = $_
        }
        
        return @{ code = -1; message = 'Fonts failed to download, try again!' }
    }
}
