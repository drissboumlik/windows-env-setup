
. $PWD\functions.ps1

$ProgressPreference = 'SilentlyContinue'


#region ANSWER QUESTIONS FOR WHICH STEPS TO EXECUTE
$StepsQuestions = [ordered]@{
    CMDER = [PSCustomObject]@{ Question = "- Did you already start cmder ? "; Answer = "no" }
}
 
foreach ($key in $StepsQuestions.Keys) {
     $q = $StepsQuestions[$key]
     $q.Answer = Prompt-YesOrNoWithDefault -message $q.Question -defaultOption "no"
}
#endregion

$downloadPath = $USER_ENV["USER_ENV_PATH"]

$WhatWasDoneMessages = @()

#region COPY CMDER CONFIG & ALIASES
if ($StepsQuestions["CMDER"].Answer -eq "yes") {

    $backupFile = "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml.bak"
    if (-not (Test-Path $backupFile)) {
        Copy-Item -Path "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml" -Destination $backupFile
    }
    Copy-Item -Path "$PWD\config\ConEmu.xml" -Destination "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml"
    
    Copy-Item -Path "$PWD\config\zoxide.lua" -Destination "$downloadPath\Cmder\config\zoxide.lua"
    
    $backupFile = "$downloadPath\Cmder\config\user_aliases.cmd.bak"
    if (Test-Path $backupFile) {
        Copy-Item -Path $backupFile -Destination "$downloadPath\Cmder\config\user_aliases.cmd"
    } else {
        Copy-Item -Path "$downloadPath\Cmder\config\user_aliases.cmd" -Destination $backupFile
    }
    Get-Content -Path "$PWD\config\user_aliases.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_aliases.cmd"

    $backupFile = "$downloadPath\Cmder\config\user_profile.cmd.bak"
    if (Test-Path $backupFile) {
        Copy-Item -Path $backupFile -Destination "$downloadPath\Cmder\config\user_profile.cmd"
    } else {
        Copy-Item -Path "$downloadPath\Cmder\config\user_profile.cmd" -Destination $backupFile
    }
    Get-Content -Path "$PWD\config\user_profile.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_profile.cmd"

    $WhatWasDoneMessages = Set-Success-Message -message "ConEmu.xml & user_aliases.cmd were added to Cmder successfully" -WhatWasDoneMessages $WhatWasDoneMessages
}
#endregion

What-ToDo-Next -WhatWasDoneMessages $WhatWasDoneMessages
