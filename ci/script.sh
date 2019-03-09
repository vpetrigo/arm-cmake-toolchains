#!/usr/bin/env bash

set -ex

# wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 -O gcc-arm-none-eabi.tar.bz2
curl -k -L https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 -o gcc-arm-none-eabi.tar.bz2
# curl -k -L https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-win32.zip -o gcc-arm-none-eabi.zip
tar jxf gcc-arm-none-eabi.tar.bz2
# unzip gcc-arm-none-eabi.zip
find . -maxdepth 1 -type d -path "*gcc*" -not -path . -exec mv {} gcc-arm-none-eabi \;
export PATH=`pwd`/gcc-arm-none-eabi/bin:$PATH

PROJECT_ROOT="`pwd`"

arm-none-eabi-gcc --version

cd examples/efm32/led
mkdir -p build-clang
cd build-clang

cmake .. -DCMAKE_TOOLCHAIN_FILE=${PROJECT_ROOT}/clang-arm-gcc-toolchain.cmake
cmake --build .
