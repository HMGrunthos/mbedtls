set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_SYSTEM_PROCESSOR ARM)

set(CMAKE_CXX_STANDARD 14)

# Set a default build type if none was specified
# set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_BUILD_TYPE Release)

if(MINGW OR CYGWIN OR WIN32)
    set(UTIL_SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(UTIL_SEARCH_CMD which)
endif()

set(TOOLCHAIN_PREFIX arm-none-eabi-)

set(CONFIG_DEFS "-D_GLIBCXX_HAS_GTHREADS=1 -DSTM32F777xx -DUSE_HAL_DRIVER -DUSE_FULL_LL_DRIVER -DFREERTOS=1")

execute_process(
  COMMAND ${UTIL_SEARCH_CMD} ${TOOLCHAIN_PREFIX}gcc
  OUTPUT_VARIABLE BINUTILS_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)
# Without that flag CMake is not able to pass test compilation check
if (${CMAKE_VERSION} VERSION_EQUAL "3.6.0" OR ${CMAKE_VERSION} VERSION_GREATER "3.6")
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
else()
    set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
endif()

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)

# Default C compiler flags
set(CMAKE_C_FLAGS "${CONFIG_DEFS} -Wall -Wextra -Wfatal-errors -Wno-format-truncation -Wno-unused-parameter -mcpu=cortex-m7 -std=gnu11 -ffunction-sections -fdata-sections -fstack-usage --specs=standard_c_nano_cpp.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb")
set(CMAKE_C_FLAGS_DEBUG_INIT "-g3 -Og -pedantic -DDEBUG")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE_INIT "-O3")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL_INIT "-Os")
set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT  "-O2 -g")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING "" FORCE)
# Default C++ compiler flags
set(CMAKE_CXX_FLAGS "${CONFIG_DEFS} -Wall -Wno-psabi -mcpu=cortex-m7 -ffunction-sections -fdata-sections -fno-use-cxa-atexit -fstack-usage --specs=standard_c_nano_cpp.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb")
set(CMAKE_CXX_FLAGS_DEBUG_INIT "-g3 -Og -pedantic -DDEBUG")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE_INIT "-O3")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT "-Os")
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT  "-O2 -g")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING "" FORCE)

set(CMAKE_OBJCOPY ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}size CACHE INTERNAL "size tool")

set(CMAKE_SYSROOT ${ARM_TOOLCHAIN_DIR}/../arm-none-eabi)
set(CMAKE_FIND_ROOT_PATH ${BINUTILS_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
