#!/bin/bash

dir=`dirname $0`
exe_dir="$dir/../build/bin"
exe="$exe_dir/$project_name_test"

LLVM_PROFILE_FILE="profraw" "$exe"
llvm-profdata merge -sparse "profraw" -o "profdata"
llvm-cov report "$exe" -ignore-filename-regex="\/gtest\/" -instr-profile="profdata" &> "$dir/../build/cov.log"
