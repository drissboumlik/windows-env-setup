
function Start-Setup {

    Write-Host "`nThis will setup your env with (Git, Composer, NVM, Chocolatey, Some terminal utilities, Cmder)`n"

    $StepsQuestions = Get-User-Answers

    $results = @()


    Make-Directory -path $USER_ENV_PATH

    $WhatWasDoneMessages = @()
    $WhatToDoNext = @()
    $WhatToDoNext += Set-Todo-Message -message "Your dev path is '$USER_ENV_PATH'"

    $overrideExistingEnvVars = Prompt-YesOrNoWithDefault -message "`nWould you like to override the existing environment variables"

    $output = Install-Chocolatey
    if ($output -ne 0) {
        Write-Host "Chocolatey is required to install the other tools. Please fix the issue and try again."
        return -1
    }

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
        $results += Install-Pvm -downloadPath $USER_ENV_PATH
        $results += Install-Composer -downloadPath $USER_ENV_PATH
    }

    if ($StepsQuestions["SCRIPTS"].Answer -eq "yes") {
        $results += Install-UserScripts -downloadPath $USER_ENV_PATH
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
        $results += Install-Fonts -downloadPath $USER_ENV_PATH 
    }

    if ($StepsQuestions["CMDER"].Answer -eq "yes") {
        $results += Install-Cmder -downloadPath $USER_ENV_PATH -overrideExistingEnvVars $overrideExistingEnvVars
    }

    $results | Foreach-Object {
        if ($_.code -eq 0) {
            $WhatWasDoneMessages += Set-Success-Message -message $_.message
        } else {
            $WhatWasDoneMessages += Set-Error-Message -message $_.message
        }
        
        if ($_.todo) {
            $WhatToDoNext += Set-Todo-Message -message $_.todo
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
        $results += Configure-Cmder -downloadPath $USER_ENV_PATH
    }


    $WhatWasDoneMessages = @()
    $results | Foreach-Object {
        if ($_.code -eq 0) {
            $WhatWasDoneMessages += Set-Success-Message -message $_.message
        } else {
            $WhatWasDoneMessages += Set-Error-Message -message $_.message
        }
    }

    Print-Messages -messages $WhatWasDoneMessages

    return 0
}
