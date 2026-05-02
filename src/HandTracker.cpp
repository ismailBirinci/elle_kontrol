#include "HandTracker.h"
#include <vector>
#include <cmath>

HandTracker::HandTracker() {
    // Default skin color values (need calibration)
    h_min = 0; h_max = 20;
    s_min = 50; s_max = 255;
    v_min = 50; v_max = 255;
}

HandTracker::~HandTracker() {}

void HandTracker::updateHSV(int h_min, int h_max, int s_min, int s_max, int v_min, int v_max) {
    this->h_min = h_min;
    this->h_max = h_max;
    this->s_min = s_min;
    this->s_max = s_max;
    this->v_min = v_min;
    this->v_max = v_max;
}

void HandTracker::process(const cv::Mat& input, cv::Mat& output) {
    cv::Mat hsv, mask, kernel;
    input.copyTo(output);

    // 1. Convert to HSV
    cv::cvtColor(input, hsv, cv::COLOR_BGR2HSV);

    // 2. Thresholding for skin color
    cv::inRange(hsv, cv::Scalar(h_min, s_min, v_min), cv::Scalar(h_max, s_max, v_max), mask);

    // 3. Morphological operations to clean noise
    kernel = cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5));
    cv::erode(mask, mask, kernel);
    cv::dilate(mask, mask, kernel);

    // Blur mask to smooth edges
    cv::GaussianBlur(mask, mask, cv::Size(5, 5), 0);

    // 4. Find and draw hands
    findHands(mask, output);
}

void HandTracker::findHands(const cv::Mat& mask, cv::Mat& drawing) {
    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;

    cv::findContours(mask, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);

    // Find largest contour (assume hand is largest skin-colored object)
    int largestContourIndex = -1;
    double largestArea = 0.0;

    for (size_t i = 0; i < contours.size(); i++) {
        double area = cv::contourArea(contours[i]);
        if (area > largestArea) {
            largestArea = area;
            largestContourIndex = (int)i;
        }
    }

    if (largestContourIndex != -1 && largestArea > 1000) { // arbitrary threshold
        // Draw contour
        cv::drawContours(drawing, contours, largestContourIndex, cv::Scalar(0, 255, 0), 2);

        // Convex Hull & Defects
        std::vector<int> hull_indices;
        std::vector<cv::Point> hull_points;
        std::vector<cv::Vec4i> defects;

        cv::convexHull(contours[largestContourIndex], hull_indices, false);
        cv::convexHull(contours[largestContourIndex], hull_points, true);

        if (hull_indices.size() > 3) {
            try {
                cv::convexityDefects(contours[largestContourIndex], hull_indices, defects);
            } catch (const cv::Exception&) {
                // Sometimes defects calculation fails if hull is self-intersecting or too simple
            }

            int fingerCount = 0;
            for (const auto& v : defects) {
                float depth = (float)v[3] / 256.0f;
                if (depth > 20) { // Filter shallow defects (not fingers spacing)
                    int startidx = v[0]; 
                    int endidx = v[1];
                    int faridx = v[2];

                    cv::Point start = contours[largestContourIndex][startidx];
                    cv::Point end = contours[largestContourIndex][endidx];
                    cv::Point far = contours[largestContourIndex][faridx];

                    // Draw defects
                    cv::circle(drawing, far, 5, cv::Scalar(0, 0, 255), -1);
                    fingerCount++;
                }
            }
            
            // Draw Hand Bounding Box
            cv::Rect boundingBox = cv::boundingRect(contours[largestContourIndex]);
            cv::rectangle(drawing, boundingBox, cv::Scalar(255, 0, 0), 2);
            
            // Display Finger Count
            // Note: simple defects count isn't perfect for fingers, but good estimation
            // Ideally need geometric logic (angle check) for better accuracy, 
            // but this is a starter high-FPS pipeline.
            std::string text = "Fingers: " + std::to_string(std::min(fingerCount + 1, 5)); 
            cv::putText(drawing, text, boundingBox.tl(), cv::FONT_HERSHEY_SIMPLEX, 1, cv::Scalar(255, 255, 0), 2);
        }
    }
}
