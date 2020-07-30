#!/bin/bash

dir=`dirname $0`
exe_dir="$dir/../build/bin"
exe="$exe_dir/$project_name_test"
log_dir="$dir/../build"

LLVM_PROFILE_FILE="profraw" "$exe" 2> "$log_dir/err.log"
llvm-profdata merge -sparse "profraw" -o "profdata"
llvm-cov report "$exe" -ignore-filename-regex="\/gtest\/" -instr-profile="profdata" &> "$log_dir/cov.log"
