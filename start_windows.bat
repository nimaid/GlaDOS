@echo off
REM Start GLaDOS

setlocal enabledelayedexpansion

set SCRIPT=glados.py

echo Checking for .venv virtual environment...
REM TODO: Why doesn't this work???
if exist ".venv\" (
    echo Found .venv, activating...
    call  .venv\Scripts\activate
    python !SCRIPT!
    goto END
else (
    echo Could not find .venv, looking for conda...
    where conda >nul 2>nul
    if errorlevel 0 (
        echo Found conda, checking for a virtual environment named glados...
        conda list --name glados >nul 2>nul
        if errorlevel 0 (
            call conda run -n glados python !SCRIPT!
            goto END
        ) else (
            echo Could not find a conda virtual environemnt named glados^!
            goto END
        )
    ) else (
        echo Could not find a a conda installation^!
        goto END
    )
)

END:
pause