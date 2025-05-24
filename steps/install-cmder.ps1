
#region SETUP CMDER
if ($StepsQuestions["CMDER"].Answer -eq "yes") {
    try {
        $WhatWasDoneMessages = Setup-Cmder -downloadPath $downloadPath -WhatWasDoneMessages $WhatWasDoneMessages -overrideExistingEnvVars $overrideExistingEnvVars
        $WhatToDoNext = Set-Todo-Message -message "Start cmder and Run to check for any updates : > clink update" -WhatToDoNext $WhatToDoNext
        $WhatToDoNext = Set-Todo-Message -message "Start cmder and Run 'flexprompt configure' to customize the prompt style." -WhatToDoNext $WhatToDoNext
        
        if (Test-Path "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml") {
            Copy-Item -Path "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml" -Destination "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml.bak"
        } else {
            Write-Warning "No ConEmu.xml found to backup."
        }
        Copy-Item -Path "$PWD\config\ConEmu.xml" -Destination "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml"
        
        Copy-Item -Path "$PWD\config\zoxide.lua" -Destination "$downloadPath\Cmder\config\zoxide.lua"
        
        if (Test-Path "$downloadPath\Cmder\config\user_aliases.cmd") {
            Copy-Item -Path "$downloadPath\Cmder\config\user_aliases.cmd" -Destination "$downloadPath\Cmder\config\user_aliases.cmd.bak"
        } else {
            Write-Warning "No user_aliases.cmd found to backup."
        }
        Get-Content -Path "$PWD\config\user_aliases.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_aliases.cmd"

        if (Test-Path "$downloadPath\Cmder\config\user_profile.cmd") {
            Copy-Item -Path "$downloadPath\Cmder\config\user_profile.cmd" -Destination "$downloadPath\Cmder\config\user_profile.cmd.bak"
        } else {
            Write-Warning "No user_aliases.cmd found to backup."
        }
        Get-Content -Path "$PWD\config\user_profile.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_profile.cmd"

        $WhatWasDoneMessages = Set-Success-Message -message "ConEmu.xml & user_aliases.cmd were added to Cmder successfully" -WhatWasDoneMessages $WhatWasDoneMessages
        
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "Issue with downloading/installing cmder" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }
}
#endregion