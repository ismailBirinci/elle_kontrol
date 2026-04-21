@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo ==========================================
echo  GUVENLI CALISTIRMA ONARILDI
echo ==========================================

call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul
set "PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
set "OPENCV_DIR=C:/Users/birin/Downloads/opencv/build"

set "ORIG_DIR=%CD%"
set "SAFE_ROOT=%TEMP%\HT_Fix"
set "SAFE_SRC=%SAFE_ROOT%\src_copy"
set "SAFE_BUILD=%SAFE_ROOT%\build"

echo Temizlik yapiliyor...
if exist "%SAFE_ROOT%" rmdir /s /q "%SAFE_ROOT%"
mkdir "%SAFE_SRC%"
mkdir "%SAFE_BUILD%"

echo Dosyalar kopyalaniyor...
xcopy /E /I /Q /Y "%ORIG_DIR%\src" "%SAFE_SRC%\src" >nul
echo. > "%SAFE_SRC%\CMakeLists.txt"
type "%ORIG_DIR%\CMakeLists.txt" >> "%SAFE_SRC%\CMakeLists.txt"

echo Yapilandiriliyor (CMake)...
cd /d "%SAFE_BUILD%"
cmake "%SAFE_SRC%" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR="%OPENCV_DIR%"
if %errorlevel% neq 0 (
    echo [HATA] CMake yapilandirmasi basarisiz oldu.
    if exist "CMakeFiles\CMakeError.log" type "CMakeFiles\CMakeError.log"
    pause
    exit /b 1
)

echo Derleniyor...
cmake --build . --config Release
if %errorlevel% neq 0 (
    echo [HATA] Derleme basarisiz oldu.
    pause
    exit /b 1
)

echo.
echo DLL dosyalari kopyalaniyor...
copy "%OPENCV_DIR%\x64\vc16\bin\opencv_world*.dll" . >nul
copy "%OPENCV_DIR%\x64\vc16\bin\opencv_videoio_ffmpeg*.dll" . >nul

echo Baslatiliyor...
echo ---------------------------------------------------
echo Uygulama GUVENLI DIZINDEN calistirilacak.
echo Lutfen acilan pencereyi kontrol edin.
echo ---------------------------------------------------

HandTracking.exe
if %errorlevel% neq 0 (
    echo.
    echo [HATA] Uygulama coktu veya hata ile kapandi. Hata kodu: %errorlevel%
)

echo.
echo Uygulama kapandi.
pause
