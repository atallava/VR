cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(scan_match)

find_package(PCL 1.7 REQUIRED)

include_directories(${PCL_INCLUDE_DIRS})
link_directories(${PCL_LIBRARY_DIRS})
add_definitions(${PCL_DEFINITIONS})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x") 

add_executable (scan_match scan_match.cpp)
target_link_libraries (scan_match ${PCL_LIBRARIES})