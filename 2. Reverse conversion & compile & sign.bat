@echo off
setlocal

:: Set tool paths and directories
set IMAGE_CONVERT_TOOL=Tools\3it_win64.exe
set AUDIO_CONVERT_TOOL=Tools\3at_win64.exe
set COMPILE_TOOL=Tools\3doiso.exe
set ENCRYPT_TOOL=Tools\3DOEncrypt.exe
set DATA_DIR=Data
set OUTPUT_DIR=Decompiled
set ASSETS_DIR=%OUTPUT_DIR%\assets

:: Check if Data folder exists
if not exist "%DATA_DIR%\" (
    echo Error: '%DATA_DIR%' folder not found!
    pause
    exit /b
)

:: Check if Decompiled folder exists
if not exist "%OUTPUT_DIR%\" (
    echo Error: '%OUTPUT_DIR%' folder not found!
    pause
    exit /b
)

:: Convert BannerScreen to original format with --output-path
for %%F in (png jpg bmp) do (
    if exist "%DATA_DIR%\BannerScreen.%%F" (
        echo Converting BannerScreen.%%F back to original format...
        "%IMAGE_CONVERT_TOOL%" to-banner "%DATA_DIR%\BannerScreen.%%F" --output-path "%OUTPUT_DIR%\BannerScreen"
        if %ERRORLEVEL% EQU 0 (
            echo BannerScreen.%%F converted successfully.
        ) else (
            echo Error converting BannerScreen.%%F.
            pause
            exit /b
        )
    )
)

:: Convert asset images back to original format with --output-path
for %%F in (alert.cel background.cel help.cel highlight.cel list.cel options.cel) do (
    for %%E in (png jpg bmp) do (
        if exist "%DATA_DIR%\%%F.%%E" (
            echo Converting %%F.%%E back to original format...
            "%IMAGE_CONVERT_TOOL%" to-cel "%DATA_DIR%\%%F.%%E" --output-path "%ASSETS_DIR%\%%F"
            if %ERRORLEVEL% EQU 0 (
                echo %%F.%%E converted successfully.
            ) else (
                echo Error converting %%F.%%E.
                pause
                exit /b
            )
        )
    )
)

:: Convert IMAG files back to original format with --output-path
for %%F in (bg.IMAG st.IMAG) do (
    for %%E in (png jpg bmp) do (
        if exist "%DATA_DIR%\%%F.%%E" (
            echo Converting %%F.%%E back to original format...
            "%IMAGE_CONVERT_TOOL%" to-imag "%DATA_DIR%\%%F.%%E" --output-path "%ASSETS_DIR%\%%F"
            if %ERRORLEVEL% EQU 0 (
                echo %%F.%%E converted successfully.
            ) else (
                echo Error converting %%F.%%E.
                pause
                exit /b
            )
        )
    )
)

:: Convert audio files (mp3, wav, ogg) to original format and move to assets as bgm44.aifc
for %%F in (wav mp3 ogg) do (
    if exist "%DATA_DIR%\bgm44.%%F" (
        echo Converting bgm44.%%F back to original format...
        "%AUDIO_CONVERT_TOOL%" to-sdx2 --channels=2 --freq=22050 --output-type=aifc "%DATA_DIR%\bgm44.%%F"
        if %ERRORLEVEL% EQU 0 (
            echo bgm44.%%F converted successfully.
            move "%DATA_DIR%\bgm44.%%F.sdx2.2ch.22050hz.aifc" "%ASSETS_DIR%\bgm44.aifc"
        ) else (
            echo Error converting bgm44.%%F.
            pause
            exit /b

        )
    )
)

:: Compile boot.iso
%COMPILE_TOOL% -in %OUTPUT_DIR% -out boot.iso

:: Check if boot.iso exists in the root directory
if not exist "boot.iso" (
    echo Error: boot.iso not found in the root directory.
    pause
    exit /b
)

:: Generate and encrypt boot.iso
%ENCRYPT_TOOL% genromtags boot.iso

echo.
echo boot.iso has been signed successfully!

pause
