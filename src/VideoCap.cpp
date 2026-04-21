#include "VideoCap.h"

VideoCap::VideoCap(int deviceID) : running(false), hasNewFrame(false) {
    cap.open(deviceID);
    if (!cap.isOpened()) {
        std::cerr << "Error: Unable to open camera " << deviceID << std::endl;
    } else {
        // Optimize FPS by lowering resolution to 640x480
        cap.set(cv::CAP_PROP_FRAME_WIDTH, 640);
        cap.set(cv::CAP_PROP_FRAME_HEIGHT, 480);
        // Force 30 FPS if supported
        cap.set(cv::CAP_PROP_FPS, 30);
    }
}

VideoCap::~VideoCap() {
    stop();
}

void VideoCap::start() {
    if (!cap.isOpened()) return;
    if (running) return;

    running = true;
    thread = std::thread(&VideoCap::loop, this);
}

void VideoCap::stop() {
    running = false;
    if (thread.joinable()) {
        thread.join();
    }
    cap.release();
}

void VideoCap::loop() {
    cv::Mat tempFrame;
    while (running) {
        if (cap.read(tempFrame)) {
            std::lock_guard<std::mutex> lock(mtx);
            tempFrame.copyTo(frame);
            hasNewFrame = true;
        }
    }
}

bool VideoCap::getFrame(cv::Mat& outFrame) {
    if (!hasNewFrame) return false;

    std::lock_guard<std::mutex> lock(mtx);
    frame.copyTo(outFrame);
    hasNewFrame = false; 
    return true;
}

bool VideoCap::isOpened() const {
    return cap.isOpened();
}

double VideoCap::get(int propId) const {
    return cap.get(propId);
}
