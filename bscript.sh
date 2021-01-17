#!/bin/bash
# Name - bscript.sh
# Purpose - Build Convenience Script 
# ------------------------------------

TESTS_DIR=tests
BUILD_DIR=build

function show_usage(){
    printf "BScript: Convenience bash script for C/C++ build\n\n"
    printf "Usage: %s [options [parameters]]\n" "$0"
    printf "\n"
    printf "Options:\n"
    printf " -h|--help, Display this message\n"
    printf "Parameters:\n"
    printf " unittest   : Build and run unit tests\n"
    printf " sampleapp  : Build sample application\n"
    printf " clean      : Clean build files\n"
    printf " all        : Build all targets (similar to \"%s unittest\" and \"%s sampleapp\") \n" "$0" "$0"

return 0
}

function unit_tests(){
    printf "Building Unit tests through CMake\n"
    cd ${TESTS_DIR} || exit
    if ! [ -d ${BUILD_DIR} ]; then
        mkdir ${BUILD_DIR}
    fi
    cd ${BUILD_DIR} || exit
    cmake ..
    make
    ctest
    cd ../.. || exit
return 0
}

function clean(){
    printf "Cleaning build files\n"
    rm -rf ${BUILD_DIR}    
    cd ${TESTS_DIR} || exit
    rm -rf ${BUILD_DIR}
return 0
}

function sampleapp(){
    printf "Building Sample Application\n"
    if ! [ -d ${BUILD_DIR} ]; then
        mkdir ${BUILD_DIR}
    fi
    cd ${BUILD_DIR} || exit
    cmake ..
    make
    cd .. || exit
return 0
}

while [ ! -z "$1" ]; do
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_usage
    elif [[ "$1" == "unittest" ]]; then
        unit_tests
    elif [[ "$1" == "sampleapp" ]]; then
        sampleapp
    elif [[ "$1" == "clean" ]]; then
        clean
    elif [[ "$1" == "all" ]]; then
        unit_tests
        sampleapp
    else
        show_usage
    fi
shift
done