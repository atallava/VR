cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(floating_laser)

# Use C ++11
add_definitions( -std=c++0x )

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

set( FL_INCLUDE_DIRECTORIES "${PROJECT_SOURCE_DIR}/include" )
include_directories(${FL_INCLUDE_DIRECTORIES})

# Create libraries and executables

add_library(floating_laser SHARED src/floating_laser.cc)
target_link_libraries(floating_laser ${GAZEBO_LIBRARIES} ${Boost_LIBRARIES})
