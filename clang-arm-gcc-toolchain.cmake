set(CMAKE_SYSTEM_NAME Generic-ELF)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(TOOLCHAIN_PREFIX arm-none-eabi-)
set(TOOLCHAIN_TRIPLE arm-none-eabi)
find_program(BINUTILS_PATH ${TOOLCHAIN_PREFIX}gcc NO_CACHE)

if (NOT BINUTILS_PATH)
  message(FATAL_ERROR "ARM GCC toolchain not found")
endif ()

get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)
find_program(ARM_GNU_LINKER ${TOOLCHAIN_PREFIX}ld
        PATHS "${ARM_TOOLCHAIN_DIR}"
        NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH NO_CACHE)

if (NOT ARM_GNU_LINKER)
  message(FATAL_ERROR "ARM GNU linker not found in ${ARM_TOOLCHAIN_DIR}")
endif ()
# CMake links through the Clang driver, so select the linker explicitly there.
# Do not rely on -B tool discovery, which can fall back to the host linker.
set(CMAKE_EXE_LINKER_FLAGS_INIT "--ld-path=\"${ARM_GNU_LINKER}\"")
set(CMAKE_SHARED_LINKER_FLAGS_INIT "--ld-path=\"${ARM_GNU_LINKER}\"")
set(CMAKE_MODULE_LINKER_FLAGS_INIT "--ld-path=\"${ARM_GNU_LINKER}\"")

set(ARM_GCC_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
execute_process(COMMAND ${ARM_GCC_C_COMPILER} -print-sysroot
        OUTPUT_VARIABLE ARM_GCC_SYSROOT OUTPUT_STRIP_TRAILING_WHITESPACE)
# get GNU ARM GCC version
execute_process(COMMAND ${ARM_GCC_C_COMPILER} --version
        OUTPUT_VARIABLE ARM_GCC_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
string(REGEX MATCH "[0-9]+\.[0-9]+\.[0-9]+" ARM_GCC_VERSION ${ARM_GCC_VERSION})
# set compiler triple
set(triple ${TOOLCHAIN_TRIPLE})
set(CMAKE_ASM_COMPILER clang)
set(CMAKE_ASM_COMPILER_TARGET ${triple})
set(CMAKE_C_COMPILER clang)
set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_CXX_COMPILER_TARGET ${triple})

set(CMAKE_C_FLAGS_INIT " -B${ARM_TOOLCHAIN_DIR}")
set(CMAKE_CXX_FLAGS_INIT " -B${ARM_TOOLCHAIN_DIR} ")
# Without that flag CMake is not able to pass test compilation check
if (${CMAKE_VERSION} VERSION_EQUAL "3.6.0" OR
  ${CMAKE_VERSION} VERSION_GREATER "3.6")
  set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
else ()
  string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -nostdlib")
endif ()

# Prefer tools belonging to the selected Clang, including distro packages whose
# PATH entries have version suffixes (for example, llvm-size-22).
find_program(CLANG_TOOL_PATH NAMES "${CMAKE_C_COMPILER}"
        NO_CMAKE_FIND_ROOT_PATH NO_CACHE)
set(CLANG_TOOL_DIR "")
set(CLANG_TOOL_MAJOR "")

if (CLANG_TOOL_PATH)
  get_filename_component(CLANG_TOOL_REALPATH "${CLANG_TOOL_PATH}" REALPATH)
  get_filename_component(CLANG_TOOL_DIR "${CLANG_TOOL_REALPATH}" DIRECTORY)
  execute_process(COMMAND "${CLANG_TOOL_PATH}" --version
            OUTPUT_VARIABLE CLANG_TOOL_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)

  if (CLANG_TOOL_VERSION MATCHES "clang version ([0-9]+)")
    set(CLANG_TOOL_MAJOR "${CMAKE_MATCH_1}")
  endif ()
endif ()

function(clang_find_postbuild_tool tool output)
  set(names "llvm-${tool}")

  if (CLANG_TOOL_MAJOR)
    list(PREPEND names "llvm-${tool}-${CLANG_TOOL_MAJOR}")
  endif ()

  find_program(selected_tool NAMES ${names} HINTS "${CLANG_TOOL_DIR}"
            NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH NO_CACHE)

  if (NOT selected_tool)
    find_program(selected_tool NAMES ${names}
                NO_CMAKE_FIND_ROOT_PATH NO_CACHE)
  endif ()

  if (NOT selected_tool)
    find_program(selected_tool NAMES "${TOOLCHAIN_PREFIX}${tool}"
                PATHS "${ARM_TOOLCHAIN_DIR}"
                NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH NO_CACHE)

    if (selected_tool)
      message(STATUS "LLVM ${tool} not found; using ${selected_tool}")
    endif ()
  endif ()

  if (NOT selected_tool)
    message(FATAL_ERROR "Neither LLVM ${tool} nor ARM GNU ${tool} was found")
  endif ()

  set(${output} "${selected_tool}" PARENT_SCOPE)
endfunction()

clang_find_postbuild_tool(objcopy CLANG_OBJCOPY)
clang_find_postbuild_tool(size CLANG_SIZE)
set(CMAKE_OBJCOPY "${CLANG_OBJCOPY}" CACHE INTERNAL "objcopy tool" FORCE)
set(CMAKE_SIZE_UTIL "${CLANG_SIZE}" CACHE INTERNAL "size tool" FORCE)
# Default C compiler flags
set(CMAKE_C_FLAGS_DEBUG_INIT "-g3 -Og -Wall -pedantic -DDEBUG")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE_INIT "-O3 -Wall")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL_INIT "-Oz -Wall")
set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "-O2 -g -Wall")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING "" FORCE)
# Default C++ compiler flags
set(TOOLCHAIN_CXX_INCLUDE_DIRS_FLAG "")
string(APPEND TOOLCHAIN_CXX_INCLUDE_DIRS_FLAG " -cxx-isystem ${ARM_GCC_SYSROOT}/include/c++/${ARM_GCC_VERSION}")
string(APPEND TOOLCHAIN_CXX_INCLUDE_DIRS_FLAG " -cxx-isystem ${ARM_GCC_SYSROOT}/include/c++/${ARM_GCC_VERSION}/arm-none-eabi")
string(APPEND TOOLCHAIN_CXX_INCLUDE_DIRS_FLAG " -cxx-isystem ${ARM_GCC_SYSROOT}/include/c++/${ARM_GCC_VERSION}/backward")
set(CMAKE_CXX_FLAGS_DEBUG_INIT "-g3 -Og -Wall -pedantic -DDEBUG ${TOOLCHAIN_CXX_INCLUDE_DIRS_FLAG}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE_INIT "-O3 -Wall ${TOOLCHAIN_CXX_INCLUDE_DIRS_FLAG}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT "-Oz -Wall ${TOOLCHAIN_CXX_INCLUDE_DIRS_FLAG}")
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O2 -g -Wall ${TOOLCHAIN_CXX_INCLUDE_DIRS_FLAG}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING "" FORCE)

set(CMAKE_SYSROOT ${ARM_GCC_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${ARM_GCC_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
