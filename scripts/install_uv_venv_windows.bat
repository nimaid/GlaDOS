@echo off

set "MAIN_DIR=%CD%/.."
cd %MAIN_DIR%

set "REQUIREMENTS_TXT=%1"

echo Installing uv with pip...
pip install --upgrade uv
if errorlevel 1 goto FAIL

echo Creating virtual environment with uv...
uv venv --python 3.12.8
call  .venv\Scripts\activate
if errorlevel 1 goto FAIL

echo Installing %REQUIREMENTS_TXT%...
uv pip install -r %REQUIREMENTS_TXT%
if errorlevel 1 goto FAIL

:SUCCESS
echo Virtual environment created!
exit /B 0

:FAIL
echo Failed to create virtual environment with uv!
exit /B 1