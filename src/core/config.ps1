
function Get-EnvConfig {
    param($rootPath)
    
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
    param($configTable, $rootPath)
    
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

# Root path of the script
$Global:SETUP_ROOT = (Resolve-Path "$PSScriptRoot\..\..").Path

# Load configuration from .env (or .env.example as fallback)
$envConfig = Get-EnvConfig -rootPath $Global:SETUP_ROOT
$globalPaths = Build-Paths -configTable $envConfig -rootPath $Global:SETUP_ROOT

# Set global variables from config
$Global:CMDER_FILES_PATH = $globalPaths['CMDER_FILES_PATH']
$Global:COMPOSER_FILES_PATH = $globalPaths['COMPOSER_FILES_PATH']
$Global:COMPOSER_V1_FILES_PATH = $globalPaths['COMPOSER_V1_FILES_PATH']
$Global:GIT_FILES_PATH = $globalPaths['GIT_FILES_PATH']
$Global:FONTS_FILES_PATH = $globalPaths['FONTS_FILES_PATH']
$Global:FONTS_LINKS_FILE_PATH = $globalPaths['FONTS_LINKS_FILE_PATH']
$Global:USER_SCRIPTS_FILES_PATH = $globalPaths['USER_SCRIPTS_FILES_PATH']
$Global:USER_SCRIPT_BAT_SKELETON_PATH = $globalPaths['USER_SCRIPT_BAT_SKELETON_PATH']

# Installation directory names
$Global:PVM_INSTALLATION_DIRECTORY_NAME = $globalPaths['PVM_INSTALLATION_DIRECTORY_NAME']
$Global:CMDER_INSTALLATION_DIRECTORY_NAME = $globalPaths['CMDER_INSTALLATION_DIRECTORY_NAME']
$Global:FONTS_INSTALLATION_DIRECTORY_NAME = $globalPaths['FONTS_INSTALLATION_DIRECTORY_NAME']
$Global:TOOLS_INSTALLATION_DIRECTORY_PATH = $globalPaths['TOOLS_INSTALLATION_DIRECTORY_PATH']
$Global:COMPOSER_V1_INSTALLATION_DIRECTORY_PATH = $globalPaths['COMPOSER_V1_INSTALLATION_DIRECTORY_PATH']

# Environment variables
$Global:ENV_FILE = "$SETUP_ROOT\.env"
$Global:USER_ENV_PATH = $globalPaths['USER_ENV_PATH']
$Global:PHP_INSTALLATION_PATH = $globalPaths['PHP_INSTALLATION_PATH']
$Global:DEV_TOOLS_ENV_VAR = $globalPaths['DEV_TOOLS_ENV_VAR']

# Storage paths
$Global:STORAGE_PATH = $globalPaths['STORAGE_PATH']

# Log paths
$Global:LOG_ERROR_PATH = $globalPaths['LOG_ERROR_PATH']
$Global:PATH_VAR_BACKUP_PATH = $globalPaths['PATH_VAR_BACKUP_PATH']

# External URLs
$Global:CHOCOLATEY_INSTALL_URL = $globalPaths['CHOCOLATEY_INSTALL_URL']
$Global:PVM_URL = $globalPaths['PVM_URL']
$Global:USER_SCRIPTS_URL = $globalPaths['USER_SCRIPTS_URL']
$Global:COMPOSER_V1_URL = $globalPaths['COMPOSER_V1_URL']
$Global:CMDER_URL = $globalPaths['CMDER_URL']
$Global:CLINK_FLEX_PROMPT_URL = $globalPaths['CLINK_FLEX_PROMPT_URL']
