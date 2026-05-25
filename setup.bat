@echo off
setlocal

rem Run PowerShell with the provided arguments
SET FILE_TARGET=%~dp0\src\setup.ps1
where pwsh >nul 2>&1
if %ERRORLEVEL%==0 (
    pwsh -NoProfile -ExecutionPolicy Bypass -File "%FILE_TARGET%" %ARGS%
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%FILE_TARGET%" %ARGS%
)

endlocal
