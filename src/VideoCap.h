#ifndef VIDEOCAP_H
#define VIDEOCAP_H

#include <opencv2/opencv.hpp>
#include <thread>
#include <mutex>
#include <atomic>
#include <iostream>

class VideoCap {
public:
    VideoCap(int deviceID);
    ~VideoCap();

    void start();
    void stop();
    bool getFrame(cv::Mat& frame);
    bool isOpened() const;
    double get(int propId) const;

private:
    void loop();

    cv::VideoCapture cap;
    cv::Mat frame;
    std::thread thread;
    std::mutex mtx;
    std::atomic<bool> running;
    std::atomic<bool> hasNewFrame;
};

#endif // VIDEOCAP_H
