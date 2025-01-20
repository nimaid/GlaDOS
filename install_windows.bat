@echo off
REM Download and install the required dependencies for the project on Windows

:: Enable delayed expansion for working with variables inside loops
setlocal enabledelayedexpansion

echo Testing for existing CUDA installation...
nvcc --version >nul 2>nul
if errorlevel 0 (
    echo Found existing CUDA installation^!
    
    call scripts\install_uv_venv_windows.bat requirements_cuda.txt
    if errorlevel 1 goto ENV_ERROR
) else (
    echo Could not find CUDA^!
    echo.
    :INSTALL_PROMPT
    echo You may choose from several installation methods:
    echo.
    echo 1. CPU only [Universal]
    echo 2. CUDA accelerated [Nvidia]
    set /p install_choice= Please enter your desired install option: 
    echo !install_choice!
    if "!install_choice!"=="1" (
        echo Installing CPU only [Universal].
        
        echo Checking for pip...
        where pip >nul 2>nul
        if errorlevel 0 (
            echo Found existing pip^!
            
            call scripts\install_uv_venv_windows.bat requirements.txt
            if errorlevel 1 goto ENV_ERROR
            
            goto DOWNLOAD_MODELS
        ) else (
            echo Could not find pip^!
        )
    ) else if "!install_choice!"=="2" (
        echo Installing CUDA accelerated [Nvidia].
    ) else (
        echo Invalid option.
        echo.
        goto INSTALL_PROMPT
    )

    echo Checking if conda is already installed...
    where conda >nul 2>nul
    if errorlevel 0 (
        echo Conda is already installed^!
        set CONDA_PATH=conda
    ) else (
        echo Could not find conda^!
        
        call scripts\install_conda_windows.bat
        if errorlevel 1 goto CONDA_ERROR

        set "CONDA_PATH=%USERPROFILE%\Miniconda3\Scripts\conda.exe"
    )
    
    echo Checking if virtual environment is already installed...
    "!CONDA_PATH!" list --name glados >nul 2>nul
    if errorlevel 0 (
        echo Virtual environment already installed.
        goto DOWNLOAD_MODELS
    )
    
    echo Virtual environment not installed^!
    
    echo Creating virtual environment ^(conda^)...
    REM TODO: Nothing runs after this?!?! Not even the model download.
    if "!install_choice!"=="1" (
        call "!CONDA_PATH!" env create -f environment.yml
    ) else if "!install_choice!"=="2" (
        call "!CONDA_PATH!" env create -f environment_cuda.yml
    )
    if !errorlevel! EQU 1 goto ENV_ERROR
)
goto DOWNLOAD_MODELS

:CONDA_ERROR
echo Miniconda3 install failed!
goto END

:ENV_ERROR
echo Environment install failed!
goto END

:DOWNLOAD_MODELS
echo Downloading models...

:: Define the list of files with their URLs and local paths
:: Removed quotes around the entire string and fixed paths
set "files[0]=https://github.com/dnhkng/GlaDOS/releases/download/0.1/glados.onnx;models/glados.onnx"
set "files[1]=https://github.com/dnhkng/GlaDOS/releases/download/0.1/nemo-parakeet_tdt_ctc_110m.onnx;models/nemo-parakeet_tdt_ctc_110m.onnx"
set "files[2]=https://github.com/dnhkng/GlaDOS/releases/download/0.1/phomenizer_en.onnx;models/phomenizer_en.onnx"
set "files[3]=https://github.com/dnhkng/GlaDOS/releases/download/0.1/silero_vad.onnx;models/silero_vad.onnx"

:: Loop through the list
for /l %%i in (0,1,3) do (
    for /f "tokens=1,2 delims=;" %%a in ("!files[%%i]!") do (
        set "url=%%a"
        set "file=%%b"
        
        echo Checking file: !file!
        
        if exist "!file!" (
            echo File "!file!" already exists.
        ) else (
            echo Downloading !file!...
            curl -L "!url!" --create-dirs -o "!file!"
            if !errorlevel! equ 1 goto DOWNLOAD_FAILED
            
            if exist "!file!" (
                echo Download successful.
            ) else (
                :DOWNLOAD_FAILED
                echo Download failed for !file!
                echo URL: !url!
                goto END
            )
        )
    )
)

echo Installation complete!

:END
pause