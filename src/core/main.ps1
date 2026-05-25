
function Start-Setup {

    Write-Host "`nThis will setup your env with (Git, Composer, NVM, Chocolatey, Some terminal utilities, Cmder)`n"

    $StepsQuestions = Get-User-Answers

    $customPath = Read-Host "Where would you like to download the tools? (default: $USER_ENV_PATH)"
    
    if ([string]::IsNullOrWhiteSpace($customPath)) {
        $customPath = $USER_ENV_PATH
    }
    
    if ($customPath -and $customPath -notmatch '^[A-Za-z]:\\.+') {
        Write-Host "Invalid path. Please provide a valid absolute path (e.g., C:\dev-tools)."
        return -1
    }
    
    $created = Make-Directory -path $customPath
    if ($created -ne 0) {
        Write-Host "Failed to create the directory at '$customPath'. Please fix the issue and try again."
        return -1
    }

    $WhatWasDoneMessages = @()
    $WhatToDoNext = @()
    $WhatToDoNext += Set-Todo-Message -message "Your dev path is '$customPath'"

    $results = @()

    $results += Install-Chocolatey

    if ($StepsQuestions["GIT"].Answer -eq "yes") {
        $results += Install-Git
    }

    if ($StepsQuestions["NVM"].Answer -eq "yes") {
        $results += Install-Nvm
    }

    if ($StepsQuestions["REDIS"].Answer -eq "yes") {
        $results += Install-Redis
    }

    if ($StepsQuestions["PVM/COMPOSER"].Answer -eq "yes") {
        $results += Install-Pvm -downloadPath $customPath
        $results += Install-Composer -downloadPath $customPath
    }

    if ($StepsQuestions["SCRIPTS"].Answer -eq "yes") {
        $results += Install-UserScripts -downloadPath $customPath
    }

    if ($StepsQuestions["TOOLS"].Answer -eq "yes") {
        $results += Install-Eza
        $results += Install-Delta
        $results += Install-Bat
        $results += Install-Fzf
        $results += Install-Zoxide
        $results += Install-Tldr
    }

    if ($StepsQuestions["FONTS"].Answer -eq "yes") {
        $results += Install-Fonts -downloadPath $customPath 
    }

    if ($StepsQuestions["CMDER"].Answer -eq "yes") {
        $results += Install-Cmder -downloadPath $customPath
    }

    $code = Update-Path-Env-Variable -entry $DEV_TOOLS_ENV_VAR -asVarRef 1
    if ($code -eq 0) {
        $WhatToDoNext += Set-Todo-Message -message "Make sure to restart your terminal for the changes to take effect."
    } else {
        $WhatWasDoneMessages += Set-Error-Message -message "Failed to update the Path environment variable with $DEV_TOOLS_ENV_VAR. Please fix the issue and try again."
    }

    $results | Foreach-Object {
        $WhatWasDoneMessages += $_.messages
        if ($_.todos) {
            $WhatToDoNext += $_.todos
        }
    }

    $WhatToDoNext += Set-Todo-Message -message "Run ./followup.ps1 when you're done for additional cmder configuration"

    Print-Messages -messages $WhatWasDoneMessages -todos $WhatToDoNext

    return 0
}

function Follow-Up {
    $StepsQuestions = Get-Followup-Answers

    $results = @()

    if ($StepsQuestions["CMDER"].Answer -eq "yes") {
        $results += Configure-Cmder -downloadPath $customPath
    }


    $WhatWasDoneMessages = @()
    $results | Foreach-Object {
        $WhatWasDoneMessages += $_.message
    }

    Print-Messages -messages $WhatWasDoneMessages

    return 0
}
