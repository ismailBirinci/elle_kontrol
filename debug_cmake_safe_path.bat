@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
chcp 65001

set "SOURCE_DIR=%CD%"
set "BUILD_DIR=%TEMP%\HandTrackingBuild"
set "OPENCV_DIR=C:/Users/birin/Downloads/opencv/build"

echo Source Dir: %SOURCE_DIR%
echo Build Dir: %BUILD_DIR%

if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%"

echo Configuring CMake...
cmake "%SOURCE_DIR%" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR="%OPENCV_DIR%"
if %errorlevel% neq 0 (
    echo CMake Configuration Failed!
    pause
    exit /b %errorlevel%
)

echo Building Project...
cmake --build . --config Release
if %errorlevel% neq 0 (
    echo Build Failed!
    pause
    exit /b %errorlevel%
)

echo Success!
pause
