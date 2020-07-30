project($project_name_test)
set(files "example_class_test.cpp")
add_executable($project_name_test ${files})

target_compile_options($project_name_test PUBLIC -fsanitize=undefined)
target_link_options($project_name_test PUBLIC -fsanitize=undefined)

target_link_libraries($project_name_test $project_name::main_test)
target_link_libraries($project_name_test ${CONAN_LIBS_GTEST})
target_include_directories($project_name_test PUBLIC ${CONAN_INCLUDE_DIRS_GTEST})

if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang AND $project_name_test_with_prof)
    target_compile_options($project_name_test PUBLIC -fprofile-instr-generate -fcoverage-mapping)
    target_link_options($project_name_test PUBLIC -fprofile-instr-generate -fcoverage-mapping)
    add_test(NAME $project_name_test COMMAND ${PROJECT_SOURCE_DIR}/../scripts/run_test_coverage.sh WORK_DIRECTORY ${PROJECT_SOURCE_DIR}/../scripts)
else()
    add_test(NAME $project_name_test COMMAND $project_name_test WORK_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif()

SET_TESTS_PROPERTIES($project_name_test PROPERTIES DEPENDS $project_name::main_test)



