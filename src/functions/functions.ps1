
function Get-EnvConfig {
    param ($rootPath)
    
    $envFile = "$rootPath\.env"

    if (-not (Test-Path $envFile)) {
        throw ".env file not found in: $rootPath"
    } else {
        Write-Verbose "Using .env from: $envFile"
    }
    
    $config = @{}
    
    # Read the file and parse key=value pairs
    Get-Content $envFile | ForEach-Object {
        # Skip empty lines and comments
        if ($_ -match '^\s*$' -or $_ -match '^\s*#') {
            return
        }
        
        # Parse key=value format
        if ($_ -match '^([^=]+)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            
            # Remove quotes if present (ensures matching quote types)
            if ($value -match "^([""'])(.*)\1$") {
                $value = $matches[2]
            }
            
            $config[$key] = $value
        }
    }
    
    return $config
}

function Build-Paths {
    param ($configTable, $rootPath)
    
    $paths = @{}
    
    foreach ($key in $configTable.Keys) {
        $value = $configTable[$key]
        
        # Keep URLs and absolute/rooted paths unchanged
        if ($value -match '^https?://' -or [System.IO.Path]::IsPathRooted($value)) {
            $paths[$key] = $value
            continue
        }

        # Leave values unchanged when they do NOT start with assets/ (invert check)
        if (-not ($value -match '^[aA]ssets[\\/]')) {
            $paths[$key] = $value
            continue
        }

        # Build full path for other relative values
        $paths[$key] = (Join-Path $rootPath $value)
    }
    
    return $paths
}

function Get-User-Answers {

    $StepsQuestions = [ordered]@{
        GIT = @{ Question = 'Download Git ?'; Answer = 'no' }
        NVM = @{ Question = 'Download NVM (Node Version Manager) ?'; Answer = 'no' }
        'PVM/COMPOSER' = @{ Question = 'Download PVM (PHP Version Manager) & Composer ?'; Answer = 'no' }
        SCRIPTS = @{ Question = 'Download user scripts ?'; Answer = 'no' }
        REDIS = @{ Question = 'Download Redis ?'; Answer = 'no' }
        TOOLS = @{ Question = 'Download TOOLS (eza, delta, bat, fzf, zoxide, tldr, Fd, Ripgrep, Jq, Yq, Tree, Curl, Wget) ?'; Answer = 'no' }
        CMDER = @{ Question = 'Download & Configure Cmder ?'; Answer = 'no' }
        FONTS = @{ Question = 'Download Nerd Fonts ?'; Answer = 'no' }
    }

    Write-Host "`nSelect which steps to execute:" -ForegroundColor Cyan
    $questionsList = @()
    $index = 1
    foreach ($key in $StepsQuestions.Keys) {
        $q = $StepsQuestions[$key]
        Write-Host "$index. $($q.Question)"
        $questionsList += @{ Index = $index; Key = $key; Question = $q.Question }
        $index++
    }
    Write-Host "0. Select all" -ForegroundColor Green

    Write-Host "`nEnter your selection (comma/space separated, e.g. 1 2 3, 1,2,3, or 0 for all). Leave blank for none." -ForegroundColor Cyan
    $userInput = Read-Host "Your choice"

    $selectedIndices = @()
    if (-not [string]::IsNullOrWhiteSpace($userInput)) {
        if ($userInput -match '^(?i)\s*(all|a|0)\s*$') {
            $selectedIndices = 1..$questionsList.Count
        } else {
            $selectedIndices = ($userInput -split '[,\s]+' | ForEach-Object {
                $value = $_.Trim()
                if ($value -eq '') { return }
                $num = $value -as [int]
                if ($null -ne $num) { return $num }
            }) | Where-Object { $_ -ge 1 -and $_ -le $questionsList.Count } | Sort-Object -Unique
        }
    }

    foreach ($item in $questionsList) {
        if ($selectedIndices -contains $item.Index) {
            $StepsQuestions[$item.Key].Answer = 'yes'
        }
    }

    if ($selectedIndices.Count -eq 0) {
        Write-Host "No valid selections made. All options will remain disabled." -ForegroundColor Yellow
    } else {
        $selectedKeys = $questionsList | Where-Object { $selectedIndices -contains $_.Index } | ForEach-Object { $_.Key }
        Write-Host "Selected: $($selectedKeys -join ', ')" -ForegroundColor Cyan
    }

    return $StepsQuestions
}

function Get-Followup-Answers {
    $StepsQuestions = [ordered]@{
        CMDER = @{ Question = "`n- Did you already start cmder ?"; Answer = 'no' }
    }

    foreach ($key in $StepsQuestions.Keys) {
        $q = $StepsQuestions[$key]
        $q.Answer = Prompt-YesOrNoWithDefault -message $q.Question -defaultOption 'no'
    }

    return $StepsQuestions
}
