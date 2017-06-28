cmake_minimum_required(VERSION 3.0)
project(sqlite3 C)

include_directories(sqlite)
if(BUILD_SHARED_LIBS AND WIN32)
    set(API "-DSQLITE_API=__declspec(dllexport)")
else()
    set(API "-DSQLITE_API=extern")
endif()
find_package(Threads REQUIRED)
add_library(sqlite3 sqlite3.c)
add_executable(sqlite3_shell shell.c sqlite3.c)

target_compile_definitions(sqlite3 PRIVATE 
    $<$<CONFIG:Debug>:-DSQLITE_DEBUG>
    ${API}
    -DSQLITE_ENABLE_RTREE
    -DSQLITE_ENABLE_UNLOCK_NOTIFY
    )
target_compile_definitions(sqlite3_shell PRIVATE 
    $<$<CONFIG:Debug>:-DSQLITE_DEBUG>
    -DSQLITE_ENABLE_RTREE
    -DSQLITE_ENABLE_UNLOCK_NOTIFY
    )
target_include_directories(sqlite3 INTERFACE $<INSTALL_INTERFACE:include>)
target_link_libraries(sqlite3 PRIVATE Threads::Threads ${CMAKE_DL_LIBS})
target_link_libraries(sqlite3_shell PRIVATE Threads::Threads ${CMAKE_DL_LIBS})
#if(VCPKG_CMAKE_SYSTEM_NAME MATCHES "WindowsStore")
#    target_compile_definitions(sqlite3 PRIVATE -DSQLITE_OS_WINRT=1)
#endif()

install(TARGETS sqlite3 sqlite3_shell EXPORT sqlite3Config    
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)
install(FILES sqlite3.h sqlite3ext.h DESTINATION include)
install(EXPORT sqlite3Config DESTINATION share/sqlite3)