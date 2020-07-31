project($project_name_test)
include(../cmake/Common.inc)
set(files "example_class_test.cpp")

macro(add_executable_test postfix_name)
    add_executable($project_name_${postfix_name} ${files})
    target_link_libraries($project_name_${postfix_name} $project_name::main_${postfix_name})
    target_link_libraries($project_name_${postfix_name} ${CONAN_LIBS_GTEST})
    target_include_directories($project_name_${postfix_name} PUBLIC ${CONAN_INCLUDE_DIRS_GTEST})
endmacro()

add_executable_test(test)

if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    find_program(llvm-profdata REQUIRED)
    find_program(llvm-cov REQUIRED)
    find_program(valgrind REQUIRED)

    add_executable_test(test_coverage)
    comp_and_link_opts(test_coverage -fprofile-instr-generate)
    comp_and_link_opts(test_coverage -fcoverage-mapping)

    add_executable_test(test_address_sanitizer)
    comp_and_link_opts(test_address_sanitizer -fsanitize=address)

    add_executable_test(test_thread_sanitizer)
    comp_and_link_opts(test_thread_sanitizer -fsanitize=thread)

    add_test(NAME test COMMAND "${PROJECT_SOURCE_DIR}/../scripts/run_tests.sh" all WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/../build")
else()
    add_test(NAME test COMMAND "${PROJECT_SOURCE_DIR}/../scripts/run_tests.sh" WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/../build")
endif()
