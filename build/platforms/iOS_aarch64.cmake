add_definitions(-stdlib=libc++)
add_definitions(-D__APPLE__ -D__IPHONE_OS__)

set(PLATFORM_IOS ON)
set(NEON ON)

set(ENV{IOS_DEVELOPER_PATH} "/Applications/Xcode.app/Contents/Developer")
if(NOT EXISTS $ENV{IOS_DEVELOPER_PATH})
    message(FATAL_ERROR "Could not find directory $ENV{IOS_DEVELOPER_PATH}."
            "Please check whether environment variable IOS_DEVELOPER is set"
            "correctly. (default is set to"
            "\"/Applications/Xcode.app/Contents/Developer\")")
endif()

set(IOS_TOOLCHAIN_PATH
        "$ENV{IOS_DEVELOPER_PATH}/Toolchains/XcodeDefault.xctoolchain/usr/bin")

set(CMAKE_C_COMPILER ${IOS_TOOLCHAIN_PATH}/clang)
set(CMAKE_CXX_COMPILER ${IOS_TOOLCHAIN_PATH}/clang++)
set(CMAKE_ASM_COMPILER ${IOS_TOOLCHAIN_PATH}/clang)

# Skip the platform compiler checks for cross compiling
set(CMAKE_CXX_COMPILER_WORKS TRUE)
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_ASM_COMPILER TRUE)

set(IOS_DEPLOYMENT_FLAG "-miphoneos-version-min=7.0")

# Require iOS SDK >= 8.1
set(CMAKE_IOS_SDK_PATH
        "$ENV{IOS_DEVELOPER_PATH}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/")

set(CMAKE_OSX_SYSROOT ${CMAKE_IOS_SDK_PATH})
set(CMAKE_FIND_ROOT_PATH ${CMAKE_IOS_SDK_PATH})

#only search the iOS sdks, not the remainder of the host filesystem
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -arch arm64 -arch arm64e  ${IOS_DEPLOYMENT_FLAG}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch arm64 -arch arm64e  ${IOS_DEPLOYMENT_FLAG}")

set(IOS_PLATFORM "OS64")
include(${PROJECT_SOURCE_DIR}/build/tools/ios.toolchain.cmake)

