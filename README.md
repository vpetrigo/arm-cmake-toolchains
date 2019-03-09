[![Build Status](https://travis-ci.com/vpetrigo/arm-cmake-toolchains.svg?branch=master)](https://travis-ci.com/vpetrigo/arm-cmake-toolchains)

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

## Customization of toolchain file

Now the `arm-gcc-toolchain.cmake` and `clang-arm-gcc-toolchain.cmake` files use `arm-none-eabi` compiler triple and prefix. In case
you want to use another compiler you should change the `TOOLCHAIN_PREFIX` variable in both CMake toolchain files and `TOOLCHAIN_TRIPLE` for
Clang-specific file only:

```cmake
# arm-gcc-toolchain.cmake and clang-arm-gcc-toolchain.cmake
set(TOOLCHAIN_PREFIX <your-compiler-prefix>)
# clang-arm-gcc-toolchain.cmake ONLY
set(TOOLCHAIN_TRIPLE <your-compiler-triple>)
```

Also some options which is essential for **Cortex-M** specific compiler (`arm-none-eabi`) might be not relevant for your compiler.
In that case you should simply delete obsolete lines from toolchain CMake file. For example the line below is not relevant for
uClinux compiler:

```cmake
set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
```

And that line can be deleted while you use `arm-uclinuxeabi` compiler without any side effect.

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

- `prepend_cur_dir`:

```cmake
# prepend ${CMAKE_CURRENT_SOURCE_DIR} to a directory
# so that you have the full path to a header/source file
# and store the result in the provided ${variable}
prepend_cur_dir(full_path_to_dir dir)
# the ${full_path_to_dir} for dir/ might be like:
${full_path_to_dir} -> C:/Users/SpecificUser/Project/dir
```

- `firmware_size`:

```cmake
# function that adds custom target that will
# output resulted executable image size by using 
# binutils size command
add_executable(hello_world main.c)
...
firmware_size(hello_world)
# Possible output:
# text    data    bss     dec     hex     filename
# 294880  81920   11592   388392  5ed28   hello_world
```

- `generate_object`:

```cmake
# function that adds custom target that will
# generate additional output file with specified
# type by using binutils objcopy
add_executable(hello_world main.c)
...
generate_object(hello_world .hex ihex)
# in addition to .elf file the hex file for
# hello_world firmware would be generated
```
