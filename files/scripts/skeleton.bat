@echo off
setlocal

rem Run PowerShell with the provided arguments
SET FILE_TARGET=__FILE_TARGET__
powershell -ExecutionPolicy Bypass -File "%FILE_TARGET%" %*

endlocal