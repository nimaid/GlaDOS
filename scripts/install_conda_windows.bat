@echo off

set ORIGDIR="%CD%"

set MINICONDA_PATH=%USERPROFILE%\Miniconda3
set CONDA_INSTALLER=%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%-condainstall.exe
set "OS="
set "CONDA_INSTALLER_LINK="

where conda >nul 2>nul
if errorlevel 0 goto CONDAFOUND

:INSTALLCONDA
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT set CONDA_INSTALLER_LINK=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86.exe
if %OS%==64BIT set CONDA_INSTALLER_LINK=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe

echo Downloading Miniconda3 (This will take while, please wait)...
powershell -Command "(New-Object Net.WebClient).DownloadFile('%CONDA_INSTALLER_LINK%', '%CONDA_INSTALLER%')" >nul 2>nul
if errorlevel 1 goto CONDAERROR

echo Installing Miniconda3 (This will also take a while, please wait)...
start /wait /min "Installing Miniconda3..." "%CONDA_INSTALLER%" /InstallationType=JustMe /S /D="%MINICONDA_PATH%"
del "%CONDA_INSTALLER%"
if not exist "%MINICONDA_PATH%\" (goto CONDAERROR)

"%MINICONDA_PATH%\Scripts\conda.exe" init
if errorlevel 1 goto CONDAERROR

echo Miniconda3 has been installed!
goto END

:CONDAERROR
echo Miniconda3 install failed!
exit /B 1

:CONDAFOUND
echo Conda is already installed!
goto END

:END
exit /B 0