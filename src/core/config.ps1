
# Root path of the script
$Global:SETUP_ROOT = (Resolve-Path "$PSScriptRoot\..\..").Path

# Files used to config different tools
$Global:CMDER_FILES_PATH = "$SETUP_ROOT\assets\cmder"
$Global:COMPOSER_FILES_PATH = "$SETUP_ROOT\assets\composer"
$Global:GIT_FILES_PATH = "$SETUP_ROOT\assets\git"
$Global:FONTS_FILES_PATH = "$SETUP_ROOT\assets\fonts"
$Global:USER_SCRIPTS_FILES_PATH = "$SETUP_ROOT\assets\scripts"
$Global:COMPOSER_INSTALLATION_PATH = "C:\composer"
$Global:CMDER_INSTALLATION_DIRECTORY_NAME = "Cmder"

# Environment variable
$Global:ENV_FILE = "$SETUP_ROOT\.env"
$Global:USER_ENV_PATH = "C:\DevEnv"
$Global:PHP_INSTALLATION_PATH = "C:\php"
$Global:DEV_TOOLS_ENV_VAR = "DEV_TOOLS_PATH"

# Storage paths
$Global:STORAGE_PATH = "$SETUP_ROOT\storage"

# Log paths
$Global:LOG_ERROR_PATH = "$STORAGE_PATH\logs\error.log"
$Global:PATH_VAR_BACKUP_PATH = "$STORAGE_PATH\logs\path.bak.log"

# Links
$Global:CHOCOLATEY_INSTALL_URL = 'https://chocolatey.org/install.ps1'
$Global:PVM_URL = 'https://github.com/usepvm/pvm'
$Global:USER_SCRIPTS_URL = 'https://github.com/drissboumlik/scripts.git'
$Global:COMPOSER_V1_URL = 'https://getcomposer.org/download/1.10.27/composer.phar'
$Global:CMDER_URL = 'https://github.com/cmderdev/cmder/releases/download/v1.3.25/cmder.zip'
$Global:CLINK_FLEX_PROMPT_URL = 'https://github.com/chrisant996/clink-flex-prompt.git'
