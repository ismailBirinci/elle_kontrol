@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
set "PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
set "OPENCV_DIR=C:/Users/birin/Downloads/opencv/build"

if exist build_debug rmdir /s /q build_debug
mkdir build_debug
cd build_debug

echo Running CMake...
cmake .. -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR="%OPENCV_DIR%" > cmake_output.txt 2>&1
type cmake_output.txt
