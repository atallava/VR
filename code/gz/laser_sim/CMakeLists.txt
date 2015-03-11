cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(floating_laser)

# Find packages

find_package(Boost REQUIRED COMPONENTS system)
include_directories(${Boost_INCLUDE_DIRS})
link_directories(${Boost_LIBRARY_DIRS})


find_package(Protobuf REQUIRED)

include (FindPkgConfig)
if (PKG_CONFIG_FOUND)
  pkg_check_modules(GAZEBO gazebo)
endif()


# include appropriate directories
include_directories(${GAZEBO_INCLUDE_DIRS})
link_directories(${GAZEBO_LIBRARY_DIRS})

# Create libraries and executables

add_library(floating_laser SHARED floating_laser.cc)
target_link_libraries(floating_laser ${GAZEBO_LIBRARIES} ${Boost_LIBRARIES})
