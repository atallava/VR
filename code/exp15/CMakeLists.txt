# CMake root for exp15.
# Version required.
cmake_minimum_required (VERSION 2.8)
# Project name. Let's call it ADES.
project (ADES)

set (CMAKE_BUILD_TYPE "Debug")

set( LIBRARY_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/lib" CACHE PATH
    "Target directory for all libraries." )
set( EXECUTABLE_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/bin" CACHE PATH
    "Target directory for all executables." )

add_definitions( -Wall -std=c++0x )

set( ADES_INCLUDE_DIRECTORIES "${PROJECT_SOURCE_DIR}/include" )
include_directories(${ADES_INCLUDE_DIRECTORIES})

# Add files here to compile them
add_library(ades SHARED 	
  # TODO: support_at, own library
  src/Point2D.cpp

  src/Scrap.cpp
  src/DataProcessor.cpp
  src/Test.cpp
  )

# Add files here to make executables out of them
add_executable(run_tests src/run_tests.cpp)
target_link_libraries(run_tests ades ${ADES_LIBRARIES})
