# Yüksek FPS El Takip Sistemi - Kurulum ve Çalıştırma

Bu proje, OpenCV kullanarak yüksek performanslı el takibi yapar. Çalıştırmak için sisteminizde bir C++ derleyicisi ve OpenCV kütüphanesinin kurulu olması gerekir.

## Gereksinimler

1.  **C++ Derleyicisi**: 
    - Windows için **Visual Studio 2019/2022** (C++ Masaüstü Geliştirme iş yükü ile) veya **MinGW**.
2.  **CMake**: Proje yapılandırması için. [cmake.org](https://cmake.org/download/) adresinden indirin.
3.  **OpenCV**: Görüntü işleme kütüphanesi.
    - [OpenCV Releases](https://opencv.org/releases/) sayfasından Windows sürümünü indirin.
    - `opencv/build/x64/vc15` klasörünü bir yere not edin.

## Derleme (Visual Studio ile)

1.  OpenCV'nin kurulu olduğu dizini (örn. `C:\opencv\build`) ortam değişkenlerine (Path) ekleyin veya CMake'e parametre olarak verin.
2.  Proje dizininde bir terminal açın:
    ```powershell
    mkdir build
    cd build
    cmake .. -DOpenCV_DIR="C:/opencv/build" 
    cmake --build . --config Release
    ```
    *(Not: `OpenCV_DIR` kısmını kendi OpenCV kurulum yolunuza göre değiştirin)*

## Çalıştırma

Derleme başarılı olduktan sonra `Release` klasörü içindeki `.exe` dosyasını çalıştırın:

```powershell
.\Release\HandTracking.exe
```

## Kullanım

- **Ayarlar Penceresi**: HSV (Renk, Doygunluk, Parlaklık) değerlerini ayarlayarak elinizi arka plandan ayırın.
  - Eliniz beyaz, arka plan siyah görünmelidir.
- **FPS**: Sol üst köşede anlık kare hızını görebilirsiniz.
- **Çıkış**: `q` veya `ESC` tuşuna basarak çıkın.
