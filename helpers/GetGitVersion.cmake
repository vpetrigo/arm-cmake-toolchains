find_package(Git)

# Try to get a Git version from the latest tag that starts with `v*` and matches
# Semver specification vX.Y.Z
# Set GIT_APP_VERSION variable with a list that has major, minor and patch versions
# Elements can later be acessed with the CMake `list` command, e.g.:
#     list(GET GIT_APP_VERSION 0 VERSION_MAJOR) # X
#     list(GET GIT_APP_VERSION 1 VERSION_MINOR) # Y
#     list(GET GIT_APP_VERSION 2 VERSION_PATCH) # Z
function(get_git_version)
    if (NOT GIT_FOUND)
        message(FATAL_ERROR "Cannot proceed without Git executable")
    endif ()

    # Generate a git-describe version string from Git repository tags
    execute_process(
            COMMAND ${GIT_EXECUTABLE} describe --tags --dirty --match "v*"
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_DESCRIBE_VERSION
            RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if (NOT GIT_DESCRIBE_ERROR_CODE)
        set(APP_VERSION ${GIT_DESCRIBE_VERSION})
    endif ()

    if (NOT APP_VERSION)
        # Final fallback: Just use a bogus version string that is semantically older
        # than anything else and spit out a warning to the developer.
        execute_process(
                COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                OUTPUT_VARIABLE GIT_DESCRIBE_VERSION
                RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
                OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(APP_VERSION v0.0.0-unknown-${GIT_DESCRIBE_VERSION})
        message(WARNING "Failed to determine APP_VERSION from Git tags. Using default version \"${APP_VERSION}\".")
    endif ()

    string(REPLACE "." ";" APP_VERSION "${APP_VERSION}")
    string(REGEX REPLACE "^v" "" APP_VERSION "${APP_VERSION}")
    set(GIT_APP_VERSION ${APP_VERSION} PARENT_SCOPE)
endfunction()
