set(PLATFORM_ANDROID ON)
set(NEON ON)

set(NDK_BIN "$ENV{TOOLCHAINS}/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin")
set(CMAKE_C_COMPILER "${NDK_BIN}/armv7a-linux-androideabi21-clang")
set(CMAKE_CXX_COMPILER "${NDK_BIN}/armv7a-linux-androideabi21-clang++")
set(CMAKE_AS "${NDK_BIN}/armv7a-linux-androideabi21-clang")

add_definitions(-D__ANDROID_API__=21)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D__ANDROID_API__=21")