@echo off
set "NIM_VERSION=2.0.0"
set "URL=https://nim-lang.org/download/nim-%NIM_VERSION%_windows_x64.zip"
set "INSTALL_DIR=%USERPROFILE%\nim"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
powershell -Command "Invoke-WebRequest -Uri %URL% -OutFile nim.zip"
powershell -Command "Expand-Archive nim.zip -DestinationPath %INSTALL_DIR% -Force"
del nim.zip
setx PATH "%PATH%;%INSTALL_DIR%\nim-%NIM_VERSION%\bin" >nul 2>&1
exit
