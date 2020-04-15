cmake_minimum_required(VERSION 3.5)
project(k64f_led)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CPU_FLAGS -mthumb -mcpu=cortex-m4 -mfloat-abi=soft)
set(COMPILER_FLAGS -ffreestanding -ffunction-sections -fdata-sections -fsigned-char -fmessage-length=0 -fshort-enums)
set(LINKER_FILE "${CMAKE_CURRENT_LIST_DIR}/k64f.ld")
set(NXP_SDK_DIR "${CMAKE_CURRENT_LIST_DIR}/../sdk")

add_compile_options(${CPU_FLAGS} ${COMPILER_FLAGS})
add_definitions(-DCPU_MK64FN1M0VLL12)

include(../../../utils.cmake)

if("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
    include(../../../clang_utils.cmake)
    clang_utils_get_arm_gcc_sysroot(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
    clang_utils_get_arm_gcc_multilib_dir(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
    clang_utils_get_arm_gcc_lib_dir(${ARM_GCC_C_COMPILER} ${CPU_FLAGS})
    clang_utils_get_arm_gcc_crt(${ARM_GCC_SYSROOT} ${ARM_GCC_MULTIDIR} ${ARM_GCC_LIBGCC_DIR})
    string(APPEND CMAKE_EXE_LINKER_FLAGS
        " -nostdlib -L${ARM_GCC_SYSROOT}/lib/${ARM_GCC_MULTIDIR} -L${ARM_GCC_LIBGCC_DIR}")
    string(APPEND CMAKE_EXE_LINKER_FLAGS " -lgcc -lnosys -lc")
elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
    string(REGEX MATCH ".*\.specs.*" has_specs "${CMAKE_EXE_LINKER_FLAGS}")

    if(NOT has_specs)
        string(APPEND CMAKE_EXE_LINKER_FLAGS " --specs=nosys.specs")
    endif()
endif()

string(REPLACE ";" " " _LINKER_CPU_FLAGS "${CPU_FLAGS}")
string(APPEND CMAKE_EXE_LINKER_FLAGS " ${_LINKER_CPU_FLAGS} -Wl,-T ${LINKER_FILE} -Wl,--gc-sections")
string(APPEND CMAKE_EXE_LINKER_FLAGS " -Wl,-Map=k64f_led.map")

set(sdk_src ${NXP_SDK_DIR}/fsl_common.c
    ${NXP_SDK_DIR}/fsl_gpio.c)
add_library(nxp_sdk ${sdk_src})
target_include_directories(nxp_sdk PUBLIC ${NXP_SDK_DIR})
add_executable(k64f_led main.c startup.c system.c ${CRT0_OBJ} ${CRT_OBJ})
target_link_libraries(k64f_led nxp_sdk)
set_target_properties(k64f_led PROPERTIES LINK_DEPENDS ${LINKER_FILE})

firmware_size(k64f_led)
generate_object(k64f_led .bin binary)
generate_object(k64f_led .hex ihex)

if ("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU" OR
    "${CMAKE_C_COMPILER_ID}" STREQUAL "Clang" AND ${CMAKE_C_COMPILER_VERSION} VERSION_GREATER_EQUAL "9.0")
    generate_object(k64f_led .hex ihex)
endif()
