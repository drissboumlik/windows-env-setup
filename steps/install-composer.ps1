#region DOWNLOAD COMPOSER
if ($StepsQuestions["COMPOSER"].Answer -eq "yes") {
    
    try {
        Write-Host "`nDownloading and installing PHP for Composer..."
        Refresh-Env
        pvm install $USER_ENV["PHP_VERSION_TO_INSTALL"]
        
        $Global:USER_ENV = Get-Env -filePath $ENV_FILE
        $phpPath = Get-ChildItem -Path $USER_ENV['PHP_VERSIONS_PATH'] -Directory | Select-Object -First 1

        if ($phpPath) {
            Write-Host "`nCopying $($phpPath.FullName) to C:\php8"
            Copy-Item -Path $phpPath.FullName -Destination "C:\php8" -Recurse

            Write-Host "`nDownloading Composer..."
            $params = '"/Php:{0}"' -f "C:\php8"
            Write-Host "choco install composer -y --params $params"
            choco install composer -y --params $params

            $WhatWasDoneMessages = Set-Success-Message -message "Composer was installed successfully!" -WhatWasDoneMessages $WhatWasDoneMessages
        }

        $url = "https://getcomposer.org/download/1.10.27/composer.phar"
        Download-File -url $url -output "$PWD\tools\composer-v1\composer.phar"

        # Copy composer version 1 to the composer path
        Copy-Item -Path "$PWD\tools\composer-v1" -Destination "C:\composer\v1" -Recurse
        Update-Path-Env-Variable -variableName "C:\composer\v1" -isVarName 0

        $WhatWasDoneMessages = Set-Success-Message -message "composer1 was successfully added to the PATH" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "Composer failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }

}
#endregion