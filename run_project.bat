@echo off
echo Setting up Visual Studio Environment...
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

echo Adding CMake to PATH...
set "PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"

echo Adding OpenCV DLLs to PATH...
set "OPENCV_DIR=C:/Users/birin/Downloads/opencv/build"
set "PATH=%PATH%;%OPENCV_DIR%/x64/vc16/bin;%OPENCV_DIR%/x64/vc15/bin"

echo Cleaning build directory...
if exist build rmdir /s /q build
mkdir build
cd build

echo Configuring CMake...
cmake .. -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR="%OPENCV_DIR%"
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

echo Running Application...
HandTracking.exe
pause
