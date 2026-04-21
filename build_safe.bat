@echo off
setlocal EnableDelayedExpansion

echo Setting up Visual Studio Environment...
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
set "PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"

set "OPENCV_DIR=C:/Users/birin/Downloads/opencv/build"
set "NON_ASCII_SOURCE=%CD%"
set "SAFE_SOURCE=%TEMP%\HandTracking_Source"
set "SAFE_BUILD=%TEMP%\HandTracking_Build"

echo.
echo ==========================================
echo  Avoiding Turkish Characters in Path...
echo  Original: %NON_ASCII_SOURCE%
echo  Temp Source: %SAFE_SOURCE%
echo  Temp Build: %SAFE_BUILD%
echo ==========================================

echo.
echo Cleaning Temp Directories...
if exist "%SAFE_SOURCE%" rmdir /s /q "%SAFE_SOURCE%"
if exist "%SAFE_BUILD%" rmdir /s /q "%SAFE_BUILD%"
mkdir "%SAFE_SOURCE%"
mkdir "%SAFE_SOURCE%\src"
mkdir "%SAFE_BUILD%"

echo.
echo Copying Source Files...
copy "CMakeLists.txt" "%SAFE_SOURCE%\"
copy "src\*.*" "%SAFE_SOURCE%\src\"

echo.
echo Configuring CMake...
cd /d "%SAFE_BUILD%"
cmake "%SAFE_SOURCE%" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR="%OPENCV_DIR%" || exit /b 1

echo.
echo Building...
cmake --build . --config Release || exit /b 1

echo.
echo Copying Executable Back...
copy "HandTracking.exe" "%NON_ASCII_SOURCE%\"

echo.
echo Adding OpenCV DLLs to PATH...
set "PATH=%PATH%;%OPENCV_DIR%/x64/vc16/bin;%OPENCV_DIR%/x64/vc15/bin"

echo.
echo Running Application...
cd /d "%NON_ASCII_SOURCE%"
HandTracking.exe

