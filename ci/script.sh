#!/usr/bin/env sh

set -ex

set_clang() {
    if [ ${TRAVIS_OS_NAME} = "linux" ]; then
        # Make package installation path preceed Travis installed packages in /usr/local/bin
        export PATH=/usr/bin:$PATH
        sudo update-alternatives --install /usr/bin/clang clang /usr/bin/${C_COMPILER} 1000 --slave /usr/bin/clang++ clang++ /usr/bin/${CXX_COMPILER}
        sudo update-alternatives --install /usr/bin/llvm-size llvm-size /usr/bin/${SIZE} 1000
        sudo update-alternatives --install /usr/bin/llvm-objcopy llvm-objcopy /usr/bin/${OBJCOPY} 1000
        sudo update-alternatives --install /usr/bin/lld lld /usr/bin/${LINKER} 1000
        sudo update-alternatives --install /usr/bin/ld.lld ld.lld /usr/bin/${LLD} 1000
    elif [ ${TRAVIS_OS_NAME} = "osx" ]; then
        export PATH="/usr/local/opt/${LLVM_PKG}/bin:$PATH"
    fi

    clang --version
    llvm-size --version || true
    # LLVM objcopy version 7 misses `--version` support
    llvm-objcopy -version || true
    lld --version || true
}

if [ ! -z "${TRAVIS+set}" ]; then
    case "${C_COMPILER}" in
    *clang*)
        set_clang
        ;;
    *gcc*)
        # Do nothing here at that point
        ;;
    *)
        exit 1
        ;;
esac
fi

# Download ARM GCC toolchain from the official site
# wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 -O gcc-arm-none-eabi.tar.bz2
case "${TRAVIS_OS_NAME}" in
    linux)
        ARM_GCC_URI="https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2"
        ;;
    osx)
        ARM_GCC_URI="https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-mac.tar.bz2"
        ;;
    *)
        >&2 echo "Unknown OS"
        exit 1
        ;;
esac

curl -k -L ${ARM_GCC_URI} -o gcc-arm-none-eabi.tar.bz2
# curl -k -L https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-win32.zip -o gcc-arm-none-eabi.zip
tar jxf gcc-arm-none-eabi.tar.bz2
# unzip gcc-arm-none-eabi.zip
find . -maxdepth 1 -type d -path "*gcc*" -not -path . -exec mv {} gcc-arm-none-eabi \;
export PATH=`pwd`/gcc-arm-none-eabi/bin:$PATH

PROJECT_ROOT="`pwd`"

arm-none-eabi-gcc --version

cd examples/efm32/led

if [ "${C_COMPILER}" != "${C_COMPILER%*clang*}" ]; then
    mkdir -p build-clang
    cd build-clang
    cmake .. -G Ninja -DCMAKE_TOOLCHAIN_FILE=${PROJECT_ROOT}/clang-arm-gcc-toolchain.cmake
else
    mkdir -p build-gcc
    cd build-gcc
    cmake .. -G Ninja -DCMAKE_TOOLCHAIN_FILE=${PROJECT_ROOT}/arm-gcc-toolchain.cmake
fi

cmake --build .
