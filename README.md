# CMake toolchain files for ARM GCC compiler

This repo contains CMake toolchain files that utilizes [ARM GCC](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm).

One of them `arm-gcc-toolchain.cmake` uses `arm-none-eabi-gcc` suite to build CMake project. To use it the toolchain must 
be added to the system PATH variable.

*Example for Ninja generator, Debug build*:

```sh
PATH=<path/to/arm-none-eabi>:$PATH cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE=arm-gcc-toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
```

`clang-arm-gcc-toolchain.cmake` uses Clang front-end as a compiler that has some additional code analyzer 
features with comprehensive warning/errormessages.

## Additional macros/functions in utils.cmake

In the `utils.cmake` file you can find some useful macros/functions that you can add into your CMake files. 
To do that you need to include `utils.cmake`:

```cmake
# CMakeLists.txt somewhere in your project
include(<path-to-utils-file>/utils.cmake)
```

It might be a good idea to include that file in your project's root `CMakeLists.txt` to allow other CMake files, 
which may reside in subdirectories, to use provided features.

- `subdirlist`:

```cmake
# store all subfolder names in a ${result} variable
# might be useful when you have lots of subdirectories with
# headers and do not want to type them manually
# IMPORTANT: ${result} contains paths relative to a ${current_dir}
subdirlist(result current_dir)

target_include_directories(<target> ${result})
```
