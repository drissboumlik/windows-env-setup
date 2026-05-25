
function Install-UserScripts {
    param ($downloadPath)
    
    try {
        git clone $USER_SCRIPTS_URL "$downloadPath\scripts" > $null 2>&1

        $toolsPath = "$downloadPath\tools\bin"
        $created = Make-Directory -path $toolsPath
        if ($created -ne 0) {
            throw "Failed to create tools/bin directory at $toolsPath"
        }
        $updated = Update-Path-Env-Variable -variableName $toolsPath -isVarName 0
        if ($updated -ne 0) {
            throw "Failed to update Path environment variable with $toolsPath"
        }
    
        Get-ChildItem "$downloadPath\scripts\src\commands\*" -Directory | ForEach-Object {
            Get-ChildItem "$($_.FullName)\*.ps1" | ForEach-Object {
                Write-Host $_.FullName
                $batFilePath = "$toolsPath\$($_.BaseName).bat"
                $batContent = Get-Content "$USER_SCRIPTS_FILES_PATH\skeleton.bat" -Raw
                $batContent = $batContent -replace '__FILE_TARGET__', $_.FullName
                Add-Content -Path $batFilePath -Value $batContent | Out-Null
            } | Out-Null
        } | Out-Null
        
        return @{ code = 0; message = 'User scripts were installed successfully' }
    } catch {
        $logged = Log-Data -data @{
            header = "$($MyInvocation.MyCommand.Name) - Failed to clone user scripts repository"
            exception = $_
        }
        
        return @{ code = -1; message = 'Failed to clone user scripts repository, try again!' }
    }
}
