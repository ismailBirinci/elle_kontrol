@echo off
chcp 65001
setlocal EnableDelayedExpansion

echo ==========================================
echo  SAFE BUILD V2 START
echo ==========================================

call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
set "PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
set "OPENCV_DIR=C:/Users/birin/Downloads/opencv/build"

set "ORIG_DIR=%CD%"
set "SAFE_ROOT=%TEMP%\HT_V2"
set "SAFE_SRC=%SAFE_ROOT%\src_copy"
set "SAFE_BUILD=%SAFE_ROOT%\build"

echo Cleaning...
if exist "%SAFE_ROOT%" rmdir /s /q "%SAFE_ROOT%"
mkdir "%SAFE_SRC%"
mkdir "%SAFE_BUILD%"

echo Copying Source...
xcopy /E /I /Q /Y "%ORIG_DIR%\src" "%SAFE_SRC%\src"
echo. > "%SAFE_SRC%\CMakeLists.txt"
type "%ORIG_DIR%\CMakeLists.txt" >> "%SAFE_SRC%\CMakeLists.txt"

echo Configuring...
cd /d "%SAFE_BUILD%"
cmake "%SAFE_SRC%" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR="%OPENCV_DIR%"
if %errorlevel% neq 0 (
    echo CONFIGURATION FAILED!
    if exist "CMakeFiles\CMakeError.log" type "CMakeFiles\CMakeError.log"
    exit /b 1
)

echo Building...
cmake --build . --config Release
if %errorlevel% neq 0 (
    echo BUILD FAILED!
    exit /b 1
)

echo Copying artifact...
copy "HandTracking.exe" "%ORIG_DIR%\"

echo Running...
cd /d "%ORIG_DIR%"
HandTracking.exe
