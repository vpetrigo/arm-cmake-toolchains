cmake_minimum_required(VERSION 3.5)
project(efm32gg_led)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_C_COMPILER_TARGET thumbv7m-unknown-none-eabi)
set(CMAKE_CXX_COMPILER_TARGET thumbv7m-unknown-none-eabi)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CPU_FLAGS -mthumb -mcpu=cortex-m3 -mfloat-abi=soft)
set(COMPILER_FLAGS -ffreestanding -ffunction-sections -fdata-sections -fsigned-char -fmessage-length=0 -fshort-enums)
set(SIL_GECKO_SDK "${CMAKE_CURRENT_LIST_DIR}/../gecko_sdk")
set(PLATFORM_PATH "platform/Device/SiliconLabs/EFM32GG")
set(LINKER_FILE "${CMAKE_CURRENT_LIST_DIR}/efm32gg.ld")

add_compile_options(${CPU_FLAGS} ${COMPILER_FLAGS})
add_link_options(${CPU_FLAGS})
add_definitions(-DEFM32GG990F1024)

include(../../../utils.cmake)
include(../gecko.cmake)

emlib_add(${SIL_GECKO_SDK})
emlib_inc_dir(${SIL_GECKO_SDK})
device_inc_dir(${SIL_GECKO_SDK} "EFM32GG")
device_src_dir(${SIL_GECKO_SDK} "EFM32GG")
gecko_cmsis_dir(${SIL_GECKO_SDK})

if("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
    include(../../../clang_utils.cmake)
    clang_utils_get_arm_gcc_sysroot(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
    clang_utils_get_arm_gcc_multilib_dir(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
    clang_utils_get_arm_gcc_lib_dir(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
    clang_utils_get_arm_gcc_crt(${ARM_GCC_SYSROOT} ${ARM_GCC_MULTIDIR} ${ARM_GCC_LIBGCC_DIR})
    string(APPEND CMAKE_EXE_LINKER_FLAGS
        " -nostdlib -L${ARM_GCC_SYSROOT}/lib/${ARM_GCC_MULTIDIR} -L${ARM_GCC_LIBGCC_DIR}")
    string(APPEND CMAKE_EXE_LINKER_FLAGS " -lgcc -lnano -lc")
elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
    string(REGEX MATCH ".*\.specs.*" has_specs "${CMAKE_EXE_LINKER_FLAGS}")

    if(NOT has_specs)
        string(APPEND CMAKE_EXE_LINKER_FLAGS " --specs=nano.specs")
    endif()
endif()

string(REPLACE ";" " " _LINKER_CPU_FLAGS "${CPU_FLAGS}")

add_library(emlib ${emlib_src})
target_include_directories(emlib PUBLIC ${emlib_inc} ${device_inc} ${cmsis_inc})

add_library(startup ${device_src}/startup_efm32gg.c)
target_include_directories(startup PRIVATE ${device_inc} ${cmsis_inc})
target_compile_definitions(startup PUBLIC -D__PROGRAM_START=main)
add_library(system ${device_src}/system_efm32gg.c)
target_include_directories(system PUBLIC ${emlib_inc} ${device_inc} ${cmsis_inc})

add_executable(efm32_test main.c ${efm32_test_obj} ${CRT0_OBJ} ${CRT_OBJ})
target_link_libraries(efm32_test emlib startup system)
target_link_options(efm32_test PRIVATE -Wl,--gc-sections -Wl,-T ${LINKER_FILE})

firmware_size(efm32_test sysv)
generate_object(efm32_test .bin binary)

if ("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
     generate_object(efm32_test .hex ihex)
endif()
