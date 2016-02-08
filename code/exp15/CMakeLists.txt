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

# Threading and Boost utilities
find_package( Threads REQUIRED )
list( APPEND ADES_LIBRARIES ${CMAKE_THREAD_LIBS_INIT} )

ADD_DEFINITIONS(-DBOOST_LOG_DYN_LINK)

find_package( Boost COMPONENTS log REQUIRED )
include_directories( ${Boost_INCLUDE_DIRS} )
list( APPEND ADES_LIBRARIES ${Boost_LIBRARIES} )
list( APPEND ADES_LIBRARIES "-lboost_thread" ) # Need to force linking against threads

add_definitions( -Wall -std=c++0x )

set( ADES_INCLUDE_DIRECTORIES "${PROJECT_SOURCE_DIR}/include" )
include_directories(${ADES_INCLUDE_DIRECTORIES})

# Add files here to compile them
add_library(ades SHARED 	
  # TODO: support_at, own library
  src/Point2D.cpp
  src/VehicleState.cpp
  src/NavState.cpp
  src/FlatSim.cpp

  src/Scrap.cpp
  src/PathTracker.cpp
  src/PathLocalizer.cpp
  src/DataProcessor.cpp
  src/Test.cpp
  )

# target_link_libraries(ades ${ADES_LIBRARIES})

# Add files here to make executables out of them
add_executable(run_tests src/run_tests.cpp)
target_link_libraries(run_tests ades ${ADES_LIBRARIES})

add_executable(run_surrogate_tracker src/run_surrogate_tracker.cpp)
target_link_libraries(run_surrogate_tracker ades ${ADES_LIBRARIES})
