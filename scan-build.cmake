################################################################################################
# Helper CMake file for facilitate scan-build purposes                                         #
# Its purpose is to set up the environment to allow scan-build to perform static analysis      #
# without any issues by bootstrapping some parts of toolchain specific values that are usually #
# set up by a CMAKE_TOOLCHAIN_FILE                                                             #
################################################################################################

# Set up try compiler target to static library to allow
# clang to test build without complains
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(TOOLCHAIN_PREFIX arm-none-eabi-)
# Set up the compiler for assembler files as there have not any options to pass
# to scan-build to set it up
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}gcc)

find_program(BINUTILS_PATH ${TOOLCHAIN_PREFIX}gcc NO_CACHE)
get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)
execute_process(COMMAND ${CMAKE_C_COMPILER} -print-sysroot
    OUTPUT_VARIABLE ARM_GCC_SYSROOT OUTPUT_STRIP_TRAILING_WHITESPACE)

set(CMAKE_OBJCOPY ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}size CACHE INTERNAL "size tool")

set(CMAKE_SYSROOT_COMPILE ${ARM_GCC_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${BINUTILS_PATH})
