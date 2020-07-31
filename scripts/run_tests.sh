#!/bin/bash

all=0

if [ "$1" == "all" ]; then
    all=1
fi

dir=`dirname $0`

build_dir="$dir/../build"
bin_dir="$build_dir/bin"

test_bin="$bin_dir/$project_name_test"
cov_bin="$bin_dir/$project_name_test_coverage"
addr_sanitizer_bin="$bin_dir/$project_name_test_address_sanitizer"
thread_sanitizer_bin="$bin_dir/$project_name_test_thread_sanitizer"

log_dir="$build_dir"

if [ $all == 1 ]; then
    LLVM_PROFILE_FILE="profraw" "$cov_bin"
    llvm-profdata merge -sparse "profraw" -o "profdata"
    llvm-cov report "$cov_bin" -ignore-filename-regex="\/gtest\/" -instr-profile="profdata" &> "$log_dir/coverage.log"

    "$addr_sanitizer_bin" 2> "$log_dir/address_sanitizer.log"
    "$thread_sanitizer_bin" 2> "$log_dir/thread_sanitizer.log"
    valgrind "$test_bin" &> "$log_dir/valgrind.log"

    address_sanitizer_log_size=$(stat -c%s "$log_dir/address_sanitizer.log")
    thread_sanitizer_log_size=$(stat -c%s "$log_dir/thread_sanitizer.log")

    if [ $address_sanitizer_log_size != 0 ]; then
        cat "$log_dir/address_sanitizer.log"
        exit -1;
    fi

    if [ $thread_sanitizer_log_size != 0 ]; then
        cat "$log_dir/thread_sanitizer.log"
        exit -2;
    fi
fi

"$test_bin"
