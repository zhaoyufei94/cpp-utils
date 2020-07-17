set(PLATFORM_ANDROID ON)
set(NEON ON)

set(NDK_BIN "$ENV{TOOLCHAINS}/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin")
set(CMAKE_C_COMPILER "${NDK_BIN}/aarch64-linux-android21-clang")
set(CMAKE_CXX_COMPILER "${NDK_BIN}/aarch64-linux-android21-clang++")
set(CMAKE_AS "${NDK_BIN}/aarch64-linux-android21-clang")
