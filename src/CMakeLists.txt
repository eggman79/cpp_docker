project($project_name_main)

set(files example_class.cpp)

macro(add_lib_with_deps name)
    add_library($project_name_${name} ${files})
    add_library($project_name::${name} ALIAS $project_name_${name})

    target_link_libraries($project_name_${name} ${CONAN_LIBS_BOOST})
    target_include_directories($project_name_${name} PRIVATE ${CONAN_INCLUDE_DIRS_BOOST})
endmacro()

add_lib_with_deps("main")
add_lib_with_deps("main_test")

if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang AND $project_name_test_with_prof)
    target_compile_options($project_name_main_test PUBLIC -fprofile-instr-generate -fcoverage-mapping)
    target_link_options($project_name_main_test PUBLIC -fprofile-instr-generate -fcoverage-mapping)
endif()

target_compile_options($project_name_main_test PUBLIC -fsanitize=undefined)

add_executable($project_name main.cpp)
target_link_libraries($project_name $project_name::main)

include(GNUInstallDirs)
install(TARGETS $project_name DESTINATION ${CMAKE_INSTALL_BINDIR})
