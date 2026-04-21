#include <opencv2/opencv.hpp>
#include <iostream>
#include <chrono>
#include "VideoCap.h"
#include "HandTracker.h"

int main() {
    std::cout << "DEBUG: Program baslatiliyor..." << std::endl;
    
    VideoCap cap(0); // Open default camera
    if (!cap.isOpened()) {
        std::cerr << "HATA: Kamera acilamadi (Cannot open camera)!" << std::endl;
        std::cerr << "Lutfen kameranizi baska bir uygulamanin kullanmadigindan emin olun." << std::endl;
        std::cout << "Cikmak icin bir tusa basin..." << std::endl;
        std::cin.get();
        return -1;
    }
    std::cout << "DEBUG: Kamera basariyla acildi." << std::endl;

    HandTracker tracker;

    // Create windows
    cv::namedWindow("Hand Tracking", cv::WINDOW_AUTOSIZE);
    cv::namedWindow("Settings", cv::WINDOW_AUTOSIZE);

    // Create trackbars for HSV calibration
    cv::createTrackbar("H Min", "Settings", &tracker.getHMin(), 180);
    cv::createTrackbar("H Max", "Settings", &tracker.getHMax(), 180);
    cv::createTrackbar("S Min", "Settings", &tracker.getSMin(), 255);
    cv::createTrackbar("S Max", "Settings", &tracker.getSMax(), 255);
    cv::createTrackbar("V Min", "Settings", &tracker.getVMin(), 255);
    cv::createTrackbar("V Max", "Settings", &tracker.getVMax(), 255);

    cap.start();

    cv::Mat frame, processed;
    
    // FPS Calculation vars
    int frames = 0;
    auto start_time = std::chrono::high_resolution_clock::now();
    double fps = 0.0;

    std::cout << "Starting High FPS Hand Tracking..." << std::endl;
    std::cout << "Press 'q' or ESC to exit." << std::endl;

    while (true) {
        if (cap.getFrame(frame)) {
            // Processing
            tracker.process(frame, processed);

            // FPS Calculation
            frames++;
            auto current_time = std::chrono::high_resolution_clock::now();
            std::chrono::duration<double> elapsed = current_time - start_time;
            if (elapsed.count() >= 1.0) {
                fps = frames / elapsed.count();
                frames = 0;
                start_time = current_time;
            }

            // Draw FPS
            std::string fpsText = "FPS: " + std::to_string((int)fps);
            cv::putText(processed, fpsText, cv::Point(10, 30), cv::FONT_HERSHEY_SIMPLEX, 1, cv::Scalar(0, 255, 0), 2);

            // Show result
            cv::imshow("Hand Tracking", processed);
        }

        // Handle key press
        char key = (char)cv::waitKey(1);
        if (key == 'q' || key == 27) {
            break;
        }
    }

    cap.stop();
    cv::destroyAllWindows();
    return 0;
}
