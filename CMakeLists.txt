cmake_minimum_required(VERSION 3.17)
project(ex3_files__1_ ASM C)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(ex3_files__1_
        main.c
        makefile
        makefile-test
        pstring.h
        pstring.s
        run_main-test.c)
