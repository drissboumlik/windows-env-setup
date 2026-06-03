
function Install-Fonts {
    param ($downloadPath)

    try {
        $links = Get-Content -Path $FONTS_LINKS_FILE_PATH -ErrorAction Stop | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
        if (-not $links -or $links.Count -eq 0) {
            throw 'No font links were found.'
        }

        Write-Host "`nDownloading Fonts..."

        $fontsDir = "$downloadPath\$FONTS_INSTALLATION_DIRECTORY_NAME"
        $created = Make-Directory -path $fontsDir
        if ($created -ne 0) {
            return @{ code = -1; messages = @(Set-Error-Message -message "Failed to create fonts directory at '$fontsDir'") }
        }

        $allMessages = @()
        foreach ($link in $links) {
            $res = Install-Font -fontsDir $fontsDir -url $link
            if ($res.messages) { $allMessages += $res.messages }
        }

        return @{ code = 0; messages = $allMessages; todos = @( Set-Info-Message -message "Install downloaded fonts from '$fontsDir'." ) }
    } catch {
        $logged = Log-Data -data @{header = "$($MyInvocation.MyCommand.Name) - Fonts failed to download"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message 'Fonts failed to download, try again!') }
    }
}

function Install-Font {
    param ($fontsDir, $url)

    try {
        if (-not $url) { throw 'No URL provided to Install-Font.' }

        $zipName = Split-Path -Path $url -Leaf
        $zipPath = "$fontsDir\$zipName"
        $extractPath = "$fontsDir\" + ([IO.Path]::GetFileNameWithoutExtension($zipName))

        if (Is-Directory-Not-Empty -path $extractPath) {
            return @{ code = -1; messages = @(Set-Warning-Message -message "The extraction directory '$extractPath' already exists and is not empty. Please remove it before proceeding.") }
        }

        if (Test-Path -Path $zipPath) { Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue }

        $downloadCode = Download-File -url $url -output $zipPath
        if ($downloadCode -ne 0) { throw "Failed to download fonts archive from '$url'" }

        if (Test-Path -Path $extractPath) { Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue }

        $created = Make-Directory -path $extractPath
        if ($created -ne 0) { throw "Failed to create extraction directory at '$extractPath'" }

        $extractCode = Extract-Zip -zipPath $zipPath -extractPath $extractPath
        if ($extractCode -ne 0) { throw "Failed to extract zip archive '$zipPath'" }

        Remove-Item -Path $zipPath

        $fontFiles = Get-ChildItem -Path $extractPath -Include *.ttf, *.otf -Recurse -File -ErrorAction SilentlyContinue
        if (-not $fontFiles -or $fontFiles.Count -eq 0) {
            throw "No font files were found in the downloaded archive '$zipName'."
        }

        return @{
            code = 0;
            messages = @(Set-Success-Message -message "Fonts downloaded and extracted successfully at '$extractPath'");
        }
    } catch {
        $logged = Log-Data -data @{header = "$($MyInvocation.MyCommand.Name) - Font failed to download/extract"; exception = $_ }

        return @{ code = -1; messages = @(Set-Error-Message -message "Fonts failed for '$url'") }
    }
}
