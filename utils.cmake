# Get all subdirectories under ${current_dir} and store them
# in ${result} variable
macro(subdirlist result current_dir)
    file(GLOB children ${current_dir}/*)
    set(dirlist "")

    foreach (child ${children})
        if (IS_DIRECTORY ${child})
            list(APPEND dirlist ${child})
        endif ()
    endforeach ()

    set(${result} ${dirlist})
endmacro()

# Prepend ${CMAKE_CURRENT_SOURCE_DIR} to a ${directory} name
# and save it in PARENT_SCOPE ${variable}
macro(prepend_cur_dir variable directory)
    set(${variable} ${CMAKE_CURRENT_SOURCE_DIR}/${directory})
endmacro()

# Add custom command to print firmware size in Berkley format
function(firmware_size target type)
    if (type STREQUAL "sysv")
        set(_size_type "-A")
    elseif (type STREQUAL "berkley")
        set(_size_type "-B")
    else ()
        message(FATAL_ERROR "Unknown size output format ${type}")
    endif ()

    add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_SIZE_UTIL} ${_size_type}
            "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}"
            )
endfunction()

# Add a command to generate firmare in a provided format
function(generate_object target suffix type)
    add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_OBJCOPY} -O ${type}
            "${CMAKE_CURRENT_BINARY_DIR}/${target}${CMAKE_EXECUTABLE_SUFFIX}" "${CMAKE_CURRENT_BINARY_DIR}/${target}${suffix}"
            BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/${target}${suffix}")
endfunction()

# Add custom linker script to the linker flags
function(linker_script_add path_to_script)
    string(APPEND CMAKE_EXE_LINKER_FLAGS " -T ${path_to_script}")
endfunction()

# Update a target LINK_DEPENDS property with a custom linker script.
# That allows to rebuild that target if the linker script gets changed
function(linker_script_target_dependency target path_to_script)
    get_target_property(_cur_link_deps ${target} LINK_DEPENDS)

    if (_cur_link_deps)
        string(APPEND _cur_link_deps " ${path_to_script}")
    else ()
        set(_cur_link_deps ${path_to_script})
    endif ()

    set_target_properties(${target} PROPERTIES LINK_DEPENDS ${_cur_link_deps})
endfunction()

# Add flags to enable all warning on a target
# Accepts two arguments:
# - <target> - target name to add additional compiler warning flags (GCC version)
# - <warning_to_error> - (OPTIONAL) boolean flag. If ON - mark all warnings as error. OFF by default
macro(enable_extra_warnings TARGET)
    target_compile_options(${TARGET} PRIVATE -Wall -Wextra -Wno-pedantic -Wconversion)

    if (${ARGC} GREATER 1)
        if (${ARGV1})
            target_compile_options(${TARGET} PRIVATE -Werror)
        endif ()
    endif ()
endmacro()
