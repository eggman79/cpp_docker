project($project_name_project)
cmake_minimum_required(VERSION 3.16)

include(build/conanbuildinfo.cmake)
conan_basic_setup()

option($project_name_test_with_prof "Enable profiling and coverage report analysis" ON)

add_subdirectory(src)
add_subdirectory(bench)
add_subdirectory(test)
