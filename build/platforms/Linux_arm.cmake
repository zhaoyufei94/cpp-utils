set(PLATFORM_LINUX ON)
set(USE_NEON ON)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpu=neon")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpu=neon")

set(ARM_LINUX_GCC "$ENV{TOOLCHAINS}/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin")
set(CMAKE_C_COMPILER ${ARM_LINUX_GCC}/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER ${ARM_LINUX_GCC}/arm-linux-gnueabihf-g++)
