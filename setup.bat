@echo off
setlocal

rem Run PowerShell with the provided arguments
SET FILE_TARGET=%~dp0\src\setup.ps1
powershell -ExecutionPolicy Bypass -File "%FILE_TARGET%" %*
@REM pwsh -ExecutionPolicy Bypass -File "%FILE_TARGET%" %*

endlocal
