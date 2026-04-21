cmake_minimum_required(VERSION 3.10)
project(HandTracking)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find OpenCV
find_package(OpenCV REQUIRED)

include_directories(${OpenCV_INCLUDE_DIRS})

# Avoid LNK1201 error with non-ASCII paths by embedding debug info
if(MSVC)
    add_compile_options(/Z7)
endif()

# Create headers and sources list
set(SOURCES
    src/main.cpp
    src/VideoCap.cpp
    src/HandTracker.cpp
)

set(HEADERS
    src/VideoCap.h
    src/HandTracker.h
)

add_executable(HandTracking ${SOURCES} ${HEADERS})

target_link_libraries(HandTracking ${OpenCV_LIBS})
