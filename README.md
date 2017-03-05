# CMake toolchain files for ARM GCC compiler

This repo contains CMake toolchain files that utilizes [ARM GCC](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm).

One of them `arm-gcc-toolchain.cmake` uses `arm-none-eabi-gcc` suite to build CMake project. To use it the toolchain must be added to the system PATH variable.

*Example for Ninja generator, Debug build*:

```sh
PATH=<path/to/arm-none-eabi>:$PATH cmake -DCMAKE_TOOLCHAIN_FILE=arm-gcc-toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
```

`clang-arm-gcc-toolchain.cmake` uses Clang front-end as a compiler that has some additional code analyzer features with comprehensive warning/error
messages.
