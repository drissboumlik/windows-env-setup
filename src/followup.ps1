
$ProgressPreference = 'SilentlyContinue'


# Load configuration
Get-ChildItem "$PSScriptRoot\core\*.ps1" | ForEach-Object { . $_.FullName }

# Load functions scripts
Get-ChildItem "$PSScriptRoot\functions\*.ps1" | ForEach-Object { . $_.FullName }

# Load Steps
Get-ChildItem "$PSScriptRoot\steps\*.ps1" | ForEach-Object { . $_.FullName }


$exitCode = Follow-Up
exit $exitCode