@echo off
setlocal

rem Run PowerShell with the provided arguments
SET FILE_TARGET=%~dp0__FILE_TARGET__
powershell -ExecutionPolicy Bypass -File "%FILE_TARGET%" %*

endlocal