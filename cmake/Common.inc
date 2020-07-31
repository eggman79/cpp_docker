macro(comp_and_link_opts name opts)
    target_compile_options($project_name_${name} PUBLIC ${opts})
    target_link_options($project_name_${name} PUBLIC ${opts})
endmacro()


