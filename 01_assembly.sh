#! /bin/bash


#  small / 01_assembly.sh  version  20230921


#  apadted from  http://timelessname.com/elfbin/
#  see also      http://www.muppetlabs.com/~breadbox/software/tiny/
#  see also      https://drewdevault.com/2020/01/04/Slow.html


#  To run on x86 (32-bit) Alpine Linux  ( 20230921 )
#    apk  add  build-base  bash  nasm  coreutils


#  To compile x86 (32-bit) executables on x86_64 Ubuntu  ( 20230921 )
#    apt-get  install  build-essential  binutils  gcc-multilib  nasm
#
#  see also  https://www.baeldung.com/linux/compile-32-bit-binary-on-64-bit-os


set  -o errexit


et     (){  log  ;  trace    "$@"  ;}    #  ------------------------------  et
log    (){  1>&2    echo     "$@"  ;}    #  -----------------------------  log
trace  (){  log  "+  $*"  ;  "$@"  ;}    #  ---------------------------  trace


hello_c  ()  {    #  ------------------------------------------------  hello_c

  #  dependency:  sudo  apt-get  install  gcc-multilib

  #  -xc  Input language is C.

  dd  of='10_hello.c'  status='none'  <<EOF

#include  <stdio.h>

int  main  ( int argc, char ** argv )  {
  printf  ( "Hello, printf dynamic!\n" );
  return  0;  }

EOF

  trace  gcc    10_hello.c  -o 11_hello.o          -m32  -c
  trace  gcc    11_hello.o  -o 12_hello_c_dynamic  -m32

  trace  cp     12_hello_c_dynamic  13_hello_c_dynamic_stripped
  trace  strip  --strip-all         13_hello_c_dynamic_stripped

  return  ;  }


hello_asm  ()  {    #    ------------------------------------------  hello_asm

  #  see  https://stackoverflow.com/a/34781288

  trace  dd  of='20_hello.asm'  status='none'  <<EOF

	SECTION .data

msg:	db "Hello, assembly static!",10
len:	equ \$-msg

	SECTION .text

	global _start
_start:
	mov	edx,len
	mov	ecx,msg
	mov	ebx,1
	mov	eax,4
	int	0x80

	mov	ebx,0
	mov	eax,1
	int	0x80
EOF

  trace  nasm  20_hello.asm  -o 21_hello.o  -f elf32

  trace  gcc  21_hello.o  -o 22_hello_asm_static  \
    -static  -m32  -no-pie  -nostartfiles  -nostdlib  -nodefaultlibs

  trace  cp     22_hello_asm_static  23_hello_asm_static_stripped
  trace  strip  --strip-all          23_hello_asm_static_stripped

  return  ;  }


main  ()  {    #  ------------------------------------------------------  main

  et     mkdir  -p  /tmp/small
  trace  cd         /tmp/small

  et  hello_c
  et  hello_asm

  et  ls  -n  -B  --color=auto

  return  ;  }


main
