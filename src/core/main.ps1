
function Start-Setup {

    Write-Host "`nThis will setup your env with (Git, Composer, NVM, Chocolatey, Some terminal utilities, Cmder)`n"

    $StepsQuestions = Get-User-Answers

    $customPath = Get-User-Path

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
        $results += Install-Fd
        $results += Install-Ripgrep
        $results += Install-Starship
        $results += Install-Jq
        $results += Install-Yq
        $results += Install-Tree
        $results += Install-Curl
        $results += Install-Wget
    }

    if ($StepsQuestions["FONTS"].Answer -eq "yes") {
        $results += Install-Fonts -downloadPath $customPath
    }

    if ($StepsQuestions["CMDER"].Answer -eq "yes") {
        $results += Install-Cmder -downloadPath $customPath
    }

    $res = Update-Path-Env-Variable -entry $DEV_TOOLS_ENV_VAR -asVarRef 1
    if ($res.code -eq 0) {
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

    $WhatToDoNext += Set-Todo-Message -message "Run ./followup.bat when you're done for additional cmder configuration"

    Print-Messages -messages $WhatWasDoneMessages -todos $WhatToDoNext

    return 0
}

function Follow-Up {
    $StepsQuestions = Get-Followup-Answers

    $results = @()

    $customPath = Get-User-Path -readFromEnvFile $true

    if ($StepsQuestions["CMDER"].Answer -eq "yes") {
        $results += Configure-Cmder -cmderPath "$customPath\$CMDER_INSTALLATION_DIRECTORY_NAME"
    }

    $WhatWasDoneMessages = @()
    $results | Foreach-Object {
        $WhatWasDoneMessages += $_.messages
    }

    Print-Messages -messages $WhatWasDoneMessages

    return 0
}
