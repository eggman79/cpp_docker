project($project_name_bench)
add_executable($project_name_bench bench.cpp)

target_link_libraries($project_name_bench $project_name::main)
target_link_libraries($project_name_bench ${CONAN_LIBS_BENCHMARK})
target_include_directories($project_name_bench PRIVATE ${CONAN_INCLUDE_DIRS_BENCHMARK})
