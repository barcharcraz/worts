cmake_minimum_required(VERSION 3.8)
project(libffi C)

include(CheckTypeSize)


configure_file(include/ffi.h.in include/ffi.h)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

check_type_size("long double" LONG_DOUBLE)
set(HAVE_LONG_DOUBLE_VARIANT FALSE)

set(FFI_EXEC_TRAMPOLINE_TABLE 0)
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(FFI_EXEC_TRAMPOLINE_TABLE 1)
elseif(CMAKE_SYSTEM_NAME STREQUAL "")