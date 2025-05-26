#region DOWNLOAD COMPOSER
if ($StepsQuestions["COMPOSER"].Answer -eq "yes") {
    try {
        Write-Host "`nDownloading and installing PHP for Composer..."
        Refresh-Env
        pvm install $USER_ENV["PHP_VERSION_TO_INSTALL"] "--dir=$($USER_ENV["PHP_INSTALLATION_PATH"])" > $null 2>&1
        
        Write-Host "`nInstalling Composer..."        
        $Global:ENV_FILE = "$PWD\.env"
        $Global:USER_ENV = Get-Env -filePath $ENV_FILE
        $phpPath = Get-ChildItem -Path $USER_ENV["PHP_INSTALLATION_PATH"] -Directory | Select-Object -First 1
        if ($phpPath) {
            Move-Item -Path "$($phpPath.FullName)\*" -Destination $USER_ENV["PHP_INSTALLATION_PATH"] -Force
            Remove-Item -Path $phpPath.FullName -Recurse -Force
            $params = '"/Php:{0}"' -f $phpPath
            choco install composer -y --params $params
        } else {
            choco install composer -y
        }

        $WhatWasDoneMessages = Set-Success-Message -message "Composer was installed successfully!" -WhatWasDoneMessages $WhatWasDoneMessages

        $url = "https://getcomposer.org/download/1.10.27/composer.phar"
        Download-File -url $url -output "$PWD\tools\composer-v1\composer.phar"

        # Copy composer version 1 to the composer path
        Copy-Item -Path "$PWD\tools\composer-v1" -Destination "C:\composer\v1" -Recurse
        Update-Path-Env-Variable -variableName "C:\composer\v1" -isVarName 0

        $WhatWasDoneMessages = Set-Success-Message -message "- composer1 was successfully added to the PATH" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "Composer failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }
}
#endregion