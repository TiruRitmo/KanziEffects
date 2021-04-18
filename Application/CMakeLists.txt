cmake_minimum_required(VERSION 3.5.1)
project(KanziEffects)

if(NOT TARGET Kanzi::kzappfw)
    find_package(Kanzi REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH)
endif()

include(kanzi-common)

add_executable(KanziEffects src/kanzieffects.cpp)

if(ANDROID)
    target_link_libraries(KanziEffects -Wl,--whole-archive Kanzi::kzappfw -Wl,--no-whole-archive)
else()
    target_link_libraries(KanziEffects Kanzi::kzappfw)
endif()

target_link_libraries(KanziEffects Kanzi::kzui Kanzi::kzcoreui Kanzi::kzjs)

set_target_properties(KanziEffects PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
