#! /bin/bash


#  small / 02_c_variants.sh  version  20230921


#  apadted from  https://web.archive.org/web/20160514233312/http://www.diku.dk/hjemmesider/studerende/firefly/emspace-html/node4.html


set  -o errexit


et     (){  log  ;  trace    "$@"  ;}    #  ------------------------------  et
log    (){  1>&2    echo     "$@"  ;}    #  -----------------------------  log
trace  (){  log  "+  $*"  ;  "$@"  ;}    #  ---------------------------  trace


example_2  ()  {    #  --------------------------------------------  example_2

  trace  dd  of='30_example_2.c'  status='none'  <<EOF

#include  <unistd.h>

char  hello[]  =  "Hello, C write dynamic!\n";

int  _start  ()  {
  write ( 0, hello, sizeof(hello)-1 );
  _exit ( 0 );  }

EOF

  trace  gcc  30_example_2.c  -o 31_example_2_dynamic  \
    -m32  -no-pie  -nostartfiles  -ffreestanding

  trace  cp     31_example_2_dynamic  32_example_2_dynamic_stripped
  trace  strip  --strip-all           32_example_2_dynamic_stripped

  return  ;  }


example_4  ()  {    #  --------------------------------------------  example_4

  #  20230921 I believe this syscall implementation is for 32-bit x86 only.

  trace  dd  of='40_example_4.c'  status='none'  <<EOF

#include  <syscall.h>

void  syscall_1  ( int num, int arg1 )  {
  asm  (
    "int\t\$0x80\n\t"  :
    /* output    */    :
    /* input     */    "a"(num), "b"(arg1)
    /* clobbered */  );  }

void  syscall_3  ( int num, int arg1, int arg2, int arg3 )  {
  asm  (
    "int\t\$0x80\n\t"  :
    /* output    */    :
    /* input     */    "a"(num), "b"(arg1), "c"(arg2), "d"(arg3)
    /* clobbered */  );  }

char  hello[]  =  "Hello, C asm-syscall static!\n";

int  _start  ()  {
  syscall_3 ( SYS_write, 1, (int) hello, sizeof(hello)-1);
  syscall_1 ( SYS_exit,  0 );  }

EOF

  trace  gcc  40_example_4.c  -o  41_example_4_static  \
    -m32  -no-pie  -nostartfiles  -nostdlib  -ffreestanding

  trace  cp     41_example_4_static  42_example_4_static_stripped
  trace  strip  --strip-all          42_example_4_static_stripped

  return  ;  }


example_5  ()  {    #  --------------------------------------------  example_5

  #  example 5 is example 2, modified to allow static compilation.

  trace  dd  of='50_example_5.c'  status='none'  <<EOF

#include  <unistd.h>

char  hello[]  =  "Hello, C write static!\n";

int  main  ()  {
  write ( 0, hello, sizeof(hello)-1 );
  return  0;  }

EOF

  #  20230921  -ffreestanding has no effect?  may be gratuitous?
  trace  gcc  50_example_5.c  -o 51_example_5_static  \
    -m32  -no-pie  -ffreestanding  -static

  trace  cp     51_example_5_static  52_example_5_static_stripped
  trace  strip  --strip-all          52_example_5_static_stripped

  return  ;  }


main  ()  {    #  ------------------------------------------------------  main

  et     mkdir  -p  /tmp/small
  trace  cd         /tmp/small

  et  example_2
  et  example_4
  et  example_5

  et  ls  -n  -B  --color=auto

  et  /tmp/small/31_example_2_dynamic
  et  /tmp/small/32_example_2_dynamic_stripped
  et  /tmp/small/41_example_4_static
  et  /tmp/small/42_example_4_static_stripped
  et  /tmp/small/51_example_5_static
  et  /tmp/small/52_example_5_static_stripped

  return  ;  }


main
