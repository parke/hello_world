# Hello, World!

This repository contains Bash scripts that generate multiple "Hello, world!" executables.  The goal is to compare various methods of creating small executables.  Some of the executalbes are dynamically linked.  Others are statically linked.

Read the comments in the scripts to see which dependencies need to be installed in order to run the scripts.  Note that `gcc` is invoked with `-m32`.  This will build 32-bit `x86` executables.  So you may need to have some special dependencies installed.

Run the scripts to attempt to build the executables.  The executables will be built in the `/tmp/small` directory.

# glibc versus musl

One interesting comparison is comparing the file sizes from a glibc system versus a musl system.

Here are the generated file sizes and filenames from a glibc-based `x86_64` Ubuntu 22.04 system, and a musl-based `x86` Alpine Linux 3.18 system.

```
             glibc   musl  filename
-rw-r--r--     122    122  10_hello.c
-rw-r--r--    1280   1388  11_hello.o
-rwxr-xr-x   14944  17320  12_hello_c_dynamic
-rwxr-xr-x   13656  13556  13_hello_c_dynamic_stripped
-rw-r--r--     200    200  20_hello.asm
-rw-r--r--     656    656  21_hello.o
-rwxr-xr-x    8728   8728  22_hello_asm_static
-rwxr-xr-x    8460   8460  23_hello_asm_static_stripped
-rw-r--r--     148    148  30_example_2.c
-rwxr-xr-x   13732  13648  31_example_2_dynamic
-rwxr-xr-x   13260  13196  32_example_2_dynamic_stripped
-rw-r--r--     573    573  40_example_4.c
-rwxr-xr-x   13256  13300  41_example_4_static
-rwxr-xr-x   12820  12868  42_example_4_static_stripped
-rw-r--r--     143    143  50_example_5.c
-rwxr-xr-x  746608  39028  51_example_5_static
-rwxr-xr-x  678036  13116  52_example_5_static_stripped
```

Note that:

All but the final two files are approximately the same size.

The final two files (`51` and `52`) are much smaller when generated on a musl-based system.  These files are statically linked "Hello, world!" executables that use the `write()` function.  For number `52`, the stripped, statically-linked executables are 678,036 bytes (glibc) versus 13,116 bytes (musl).  The musl-generated executable is over 50 times smaller!

# Future plans

At some point in the future, I may add additional methods of generating executables.  I'm primarily interested in generating small, statically-linked executables, mostly using the C and C++ programming languages.
