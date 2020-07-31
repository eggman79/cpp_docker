project($project_name_main)
include(../cmake/Common.inc)
set(files example_class.cpp)

macro(add_lib_with_deps name)
    add_library($project_name_${name} ${files})
    add_library($project_name::${name} ALIAS $project_name_${name})

    target_link_libraries($project_name_${name} ${CONAN_LIBS_BOOST})
    target_include_directories($project_name_${name} PRIVATE ${CONAN_INCLUDE_DIRS_BOOST})
endmacro()

add_lib_with_deps("main")
add_lib_with_deps("main_test")

if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    add_lib_with_deps("main_test_coverage")
    add_lib_with_deps("main_test_thread_sanitizer")
    add_lib_with_deps("main_test_address_sanitizer")
endif()

if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    comp_and_link_opts(main_test_coverage -fprofile-instr-generate)
    comp_and_link_opts(main_test_coverage -fcoverage-mapping)
    comp_and_link_opts(main_test_thread_sanitizer -fsanitize=thread)
    comp_and_link_opts(main_test_address_sanitizer -fsanitize=address)
endif()

add_executable($project_name main.cpp)
target_link_libraries($project_name $project_name::main)

include(GNUInstallDirs)
install(TARGETS $project_name DESTINATION ${CMAKE_INSTALL_BINDIR})
