cmake_minimum_required(VERSION 3.5)

project(utils)

add_definitions(-std=c++11)
add_definitions(-fPIC)

include(${PROJECT_SOURCE_DIR}/build/tools/get_current_time.cmake)
include(${PROJECT_SOURCE_DIR}/build/tools/set_flags.cmake)

set(MOR_VERSION_MAJOR 1)
set(MOR_VERSION_MINOR 0)
set(MOR_VERSION_PATCH 0)
set(MOR_VERSION ${MOR_VERSION_MAJOR}.${MOR_VERSION_MINOR}.${MOR_VERSION_PATCH})

# 设置目标平台
if(NOT DEFINED TARGET_PLATFORM)
    set(TARGET_PLATFORM "Linux_x86-64")
endif(NOT DEFINED TARGET_PLATFORM)

# 设置编译类型
if(NOT DEFINED CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type")
endif(NOT DEFINED CMAKE_BUILD_TYPE)

# project相关的设置
_GetCurrentTime(CURR_TIME)

message(STATUS "Project name            : ${PROJECT_NAME}")
message(STATUS "Project version         : ${MOR_VERSION}")
message(STATUS "Project update          : ${CURR_TIME}")

configure_file("${PROJECT_SOURCE_DIR}/build/version.h.in" "${PROJECT_SOURCE_DIR}/include/mor_version.h")

if(CMAKE_BUILD_TYPE MATCHES "Release")
    message(STATUS "Project build mode      : RELEASE")
else()
    message(STATUS "Project build mode      : DEBUG")
    add_definitions(-DLOG_DEBUG)
        add_definitions(-DDEBUG)
    enable_testing()
endif()
message(STATUS "Project target platform : ${TARGET_PLATFORM}")

set(PLATFORM_CMAKE_FILE "${PROJECT_SOURCE_DIR}/build/platforms/${TARGET_PLATFORM}.cmake")
if(EXISTS ${PLATFORM_CMAKE_FILE})
    include(${PLATFORM_CMAKE_FILE})
else()
    message(FATAL_ERROR "Missing cmake Makefile  : ${PLATFORM_CMAKE_FILE}")
endif()


message(STATUS "Project Compiler        : ${CMAKE_CXX_COMPILER}")

set(LIBRARY_OUTPUT_PATH     ${PROJECT_SOURCE_DIR}/output-libs/${TARGET_PLATFORM})
if (TARGET_PLATFORM MATCHES "Linux_x86-64")
    set(EXECUTABLE_OUTPUT_PATH  ${PROJECT_SOURCE_DIR}/bin)
else()
    set(EXECUTABLE_OUTPUT_PATH  ${PROJECT_SOURCE_DIR}/bin/${TARGET_PLATFORM})
endif()

include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/third)

add_subdirectory(${PROJECT_SOURCE_DIR}/test)
