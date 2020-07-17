set(PLATFORM_LINUX ON)
set(NEON ON)
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpu=neon")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpu=neon")

set(AARCH_LINUX_GCC "$ENV{TOOLCHAINS}/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin")
set(CMAKE_C_COMPILER ${AARCH_LINUX_GCC}/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${AARCH_LINUX_GCC}/aarch64-linux-gnu-g++)
