#ifndef HANDTRACKER_H
#define HANDTRACKER_H

#include <opencv2/opencv.hpp>
#include <vector>

class HandTracker {
public:
    HandTracker();
    ~HandTracker();

    void updateHSV(int h_min, int h_max, int s_min, int s_max, int v_min, int v_max);
    void process(const cv::Mat& input, cv::Mat& output);
    
    // Getters for current HSV settings (for UI trackbars)
    int& getHMin() { return h_min; }
    int& getHMax() { return h_max; }
    int& getSMin() { return s_min; }
    int& getSMax() { return s_max; }
    int& getVMin() { return v_min; }
    int& getVMax() { return v_max; }

private:
    void findHands(const cv::Mat& mask, cv::Mat& drawing);
    float distanceP2P(cv::Point a, cv::Point b);
    float getAngle(cv::Point s, cv::Point f, cv::Point e);

    int h_min, h_max, s_min, s_max, v_min, v_max;
};

#endif // HANDTRACKER_H
