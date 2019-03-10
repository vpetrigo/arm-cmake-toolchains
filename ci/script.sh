#!/usr/bin/env sh

set -ex

if [ ! -z "${TRAVIS+set}" ]; then
    # Make package installation path preceed Travis installed packages in /usr/local/bin
    export PATH=/usr/bin:$PATH
    sudo update-alternatives --install /usr/bin/clang clang /usr/bin/${C_COMPILER} 1000 --slave /usr/bin/clang++ clang++ /usr/bin/${CXX_COMPILER}
    sudo update-alternatives --install /usr/bin/llvm-size llvm-size /usr/bin/${SIZE} 1000
    sudo update-alternatives --install /usr/bin/llvm-objcopy llvm-objcopy /usr/bin/${OBJCOPY} 1000
    sudo update-alternatives --install /usr/bin/lld lld /usr/bin/${LINKER} 1000
    sudo update-alternatives --install /usr/bin/ld.lld ld.lld /usr/bin/${LLD} 1000

    clang --version
    llvm-size --version
    # LLVM objcopy version 7 misses `--version` support
    llvm-objcopy -version || true
    ld.lld --version
fi

# Download ARM GCC toolchain from the official site
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