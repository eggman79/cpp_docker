project($project_name_test)
include(../cmake/Common.inc)
set(files "example_class_test.cpp")

macro(add_executable_test postfix_name opts)
    add_executable($project_name_${postfix_name} ${files})

    if (${opts} STREQUAL " ")
    else()
        comp_and_link_opts($project_name_${postfix_name} ${opts})
    endif()

    target_link_libraries($project_name_${postfix_name} $project_name::main_${postfix_name})
    target_link_libraries($project_name_${postfix_name} ${CONAN_LIBS_GTEST})
    target_include_directories($project_name_${postfix_name} PUBLIC ${CONAN_INCLUDE_DIRS_GTEST})
endmacro()

add_executable_test(test " ")
add_executable_test(test_coverage -fprofile-instr-generate -fcoverage-mapping)
add_executable_test(test_address_sanitizer -fsanitize=address)
add_executable_test(test_thread_sanitizer -fsanitize=thread)
