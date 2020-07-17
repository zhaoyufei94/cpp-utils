set(PLATFORM_LINUX ON)
set(USE_NEON ON)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=hard")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfloat-abi=hard")
set(CROSS_COMPILING_ROOT $ENV{TOOLCHAINS}/uiot_rk3308/arm-rockchip-linux-gnueabihf)
set(CROSS_COMPILING_HOME $ENV{TOOLCHAINS}/uiot_rk3308/bin)

set(CMAKE_C_LINK_FLAGS      " --sysroot=${CROSS_COMPILING_ROOT}/sysroot -fPIE -L${CROSS_COMPILING_ROOT}/lib -lpthread  -ldl -lrt")
set(CMAKE_CXX_LINK_FLAGS    " --sysroot=${CROSS_COMPILING_ROOT}/sysroot  -L${CROSS_COMPILING_ROOT}/lib -fPIE -lpthread  -ldl -lrt")

SET(CMAKE_C_COMPILER    ${CROSS_COMPILING_HOME}/arm-rockchip-linux-gnueabihf-gcc)
SET(CMAKE_CXX_COMPILER  ${CROSS_COMPILING_HOME}/arm-rockchip-linux-gnueabihf-g++)
set(CMAKE_RANLIB        ${CROSS_COMPILING_HOME}/arm-rockchip-linux-gnueabihf-ranlib)
set(CMAKE_AR            ${CROSS_COMPILING_HOME}/arm-rockchip-linux-gnueabihf-ar)
set(CMAKE_AS            ${CROSS_COMPILING_HOME}/arm-rockchip-linux-gnueabihf-as)
set(CMAKE_STRIP         ${CROSS_COMPILING_HOME}/arm-rockchip-linux-gnueabihf-strip)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(SYSTEM_DETAILS uiot-rk3308)
set(BUILD_LINUXALSA ON)