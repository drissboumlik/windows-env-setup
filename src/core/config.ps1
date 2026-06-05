
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
$Global:SCRIPTS_FILES_PATH = $globalPaths['SCRIPTS_FILES_PATH']
$Global:SCRIPT_BAT_SKELETON_PATH = $globalPaths['SCRIPT_BAT_SKELETON_PATH']

# Installation directory names
$Global:PVM_INSTALLATION_DIRECTORY_PATH = $globalPaths['PVM_INSTALLATION_DIRECTORY_PATH']
$Global:CMDER_INSTALLATION_DIRECTORY_PATH = $globalPaths['CMDER_INSTALLATION_DIRECTORY_PATH']
$Global:FONTS_INSTALLATION_DIRECTORY_PATH = $globalPaths['FONTS_INSTALLATION_DIRECTORY_PATH']
$Global:TOOLS_INSTALLATION_DIRECTORY_PATH = $globalPaths['TOOLS_INSTALLATION_DIRECTORY_PATH']
$Global:COMPOSER_V1_INSTALLATION_DIRECTORY_PATH = $globalPaths['COMPOSER_V1_INSTALLATION_DIRECTORY_PATH']
$Global:SCRIPTS_INSTALLATION_DIRECTORY_PATH = $globalPaths['SCRIPTS_INSTALLATION_DIRECTORY_PATH']

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
$Global:SCRIPTS_URL = $globalPaths['SCRIPTS_URL']
$Global:COMPOSER_V1_URL = $globalPaths['COMPOSER_V1_URL']
$Global:CMDER_URL = $globalPaths['CMDER_URL']
$Global:CLINK_FLEX_PROMPT_URL = $globalPaths['CLINK_FLEX_PROMPT_URL']
