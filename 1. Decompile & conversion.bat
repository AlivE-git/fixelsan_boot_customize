@echo off
setlocal

:: Set tool paths and directories
set TOOL_PATH=Tools\OperaTool.exe
set IMAGE_CONVERT_TOOL=Tools\3it_win64.exe
set AUDIO_CONVERT_TOOL=Tools\3at_win64.exe
set ISO_FILE=boot_image\boot.iso
set OUTPUT_DIR=Decompiled
set DATA_DIR=Data
set ASSETS_DIR=%OUTPUT_DIR%\assets

:: Check if boot.iso exists
if not exist "%ISO_FILE%" (
    echo Error: %ISO_FILE% not found in %CD%\boot_image!
    pause
    exit /b
)

:: Delete Decompiled folder if it exists
if exist "%OUTPUT_DIR%" (
    echo Deleting existing %OUTPUT_DIR% folder...
    rd /s /q "%OUTPUT_DIR%"
)

:: Create Decompiled folder
mkdir "%OUTPUT_DIR%"

:: Run extraction
echo Running: "%TOOL_PATH%" -d "%ISO_FILE%" "%OUTPUT_DIR%"
"%TOOL_PATH%" -d "%ISO_FILE%" "%OUTPUT_DIR%"
echo Extraction process finished with code %errorlevel%.

:: Check for errors
if %errorlevel% neq 0 (
    echo Extraction failed!
    pause
    exit /b
)

echo Extraction completed successfully!

:: Create Data folder if it doesn't exist
if not exist "%DATA_DIR%" (
    mkdir "%DATA_DIR%"
)

:: Convert BannerScreen to PNG
set BANNER_FILE=%OUTPUT_DIR%\BannerScreen
if exist "%BANNER_FILE%" (
    echo Converting BannerScreen to PNG...
    "%IMAGE_CONVERT_TOOL%" to-png "%BANNER_FILE%"
    move "%OUTPUT_DIR%\BannerScreen.png" "%DATA_DIR%\BannerScreen.png"
    echo Conversion completed successfully!
) else (
    echo Warning: BannerScreen file not found in %OUTPUT_DIR%!
)

:: Convert asset images to PNG
if exist "%ASSETS_DIR%" (
    echo Converting asset images to PNG...
    for %%F in (alert.cel background.cel bg.IMAG help.cel highlight.cel list.cel options.cel st.IMAG) do (
        if exist "%ASSETS_DIR%\%%F" (
            echo Converting %%F...
            "%IMAGE_CONVERT_TOOL%" to-png "%ASSETS_DIR%\%%F"
            move "%ASSETS_DIR%\%%F.png" "%DATA_DIR%\%%F.png"
        ) else (
            echo Warning: %%F not found in %ASSETS_DIR%!
        )
    )
    echo Asset image conversion completed!
) else (
    echo Warning: Assets folder not found in %OUTPUT_DIR%!
)

:: Convert bgm44.aifc to WAV
set AUDIO_FILE=%ASSETS_DIR%\bgm44.aifc
set OUTPUT_WAV=%DATA_DIR%\bgm44.wav
set TEMP_WAV=%ASSETS_DIR%\bgm44.aifc.wav

if exist "%AUDIO_FILE%" (
    echo Converting bgm44.aifc to WAV...
    "%AUDIO_CONVERT_TOOL%" from-sdx2 --channels=2 --freq=22050 --output-type=wav "%AUDIO_FILE%"

    :: Check fie
    if exist "%TEMP_WAV%" (
        echo Renaming and moving bgm44.aifc.wav to Data...
        move "%TEMP_WAV%" "%OUTPUT_WAV%"
    ) else (
        echo Error: Converted bgm44.aifc.wav not found!
        pause
        exit /b
    )
    echo Audio conversion completed successfully!
) else (
    echo Warning: bgm44.aifc file not found in %ASSETS_DIR%!
)

pause
