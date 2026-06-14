

$ProgressPreference = 'SilentlyContinue'

# Load functions scripts
Get-ChildItem "$PSScriptRoot\functions\*.ps1" -Recurse -File | ForEach-Object { . $_.FullName }

# Load configuration
Get-ChildItem "$PSScriptRoot\core\*.ps1" -Recurse -File | ForEach-Object { . $_.FullName }

# Load Steps
Get-ChildItem "$PSScriptRoot\tools\*.ps1" -Recurse -File | ForEach-Object { . $_.FullName }


$exitCode = Start-Setup
exit $exitCode
