#! /bin/bash


#  small / 03_nasm_tiny.sh  version  20230922


#  apadted from  http://www.muppetlabs.com/~breadbox/software/tiny/


set  -o errexit


et     (){  log  ;  trace    "$@"  ;}    #  ------------------------------  et
log    (){  1>&2    echo     "$@"  ;}    #  -----------------------------  log
trace  (){  log  "+  $*"  ;  "$@"  ;}    #  ---------------------------  trace


nasm_tiny  ()  {    #  --------------------------------------------  nasm_tiny

  #  see  http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html

  trace  dd  of='60_nasm_tiny.asm'  status='none'  <<EOF

  BITS 32

		org	0x00010000

		db	0x7F, "ELF"		; e_ident
		dd	1					; p_type
		dd	0					; p_offset
		dd	\$\$					; p_vaddr
		dw	2			; e_type	; p_paddr
		dw	3			; e_machine
		dd	_start			; e_version	; p_filesz
		dd	_start			; e_entry	; p_memsz
		dd	4			; e_phoff	; p_flags
  _start:
		mov	bl, 42			; e_shoff	; p_align
		xor	eax, eax
		inc	eax			; e_flags
		int	0x80
		db	0
		dw	0x34			; e_ehsize
		dw	0x20			; e_phentsize
		db	1			; e_phnum
						; e_shentsize
						; e_shnum
						; e_shstrndx

  filesize	equ	\$ - \$\$

EOF

  trace  nasm 60_nasm_tiny.asm  -o 61_nasm_tiny  -f bin
  trace  chmod  +x  61_nasm_tiny

  return  ;  }


nasm_valid  ()  {    #  -----------------------------------------  nasm_valid

  #  see  http://www.muppetlabs.com/~breadbox/software/tiny/revisit.html

  trace  dd  of='62_nasm_valid.asm'  status='none'  <<EOF

  BITS 32

		org	0x2AB30000

  ehdr:
		db	0x7F, "ELF", 1, 1, 1	; e_ident
	times 9 db	0
		dw	2			; e_type
		dw	3			; e_machine
		dd	1			; e_version
		dd	_start			; e_entry
		dd	phdr - \$\$		; e_phoff
		dd	0			; e_shoff
		dd	0			; e_flags
		dw	ehdrsz			; e_ehsize
		dw	phdrsz			; e_phentsize
  phdr:		dd	1			; e_phnum	; p_type
						; e_shentsize
		dd	0			; e_shnum	; p_offset
						; e_shstrndx
  ehdrsz	equ	\$ - ehdr
		dw	0					; p_vaddr
  _start:	mov	bl, 42
		xor	eax, eax				; p_paddr
		inc	eax
		cmp	eax, strict dword filesz		; p_filesz
		int	0x80					; p_memsz
		dw	0
		dd	7					; p_flags
		dd	0x1000					; p_align
  phdrsz	equ	\$ - phdr

  filesz	equ	\$ - \$\$

EOF

  trace  nasm 62_nasm_valid.asm  -o 63_nasm_valid  -f bin
  trace  chmod  +x  63_nasm_valid

  return  ;  }


main  ()  {    #  ------------------------------------------------------  main

  et     mkdir  -p  /tmp/small
  trace  cd	 /tmp/small

  et  nasm_tiny
  et  nasm_valid

  et  file  /tmp/small/61_nasm_tiny
  et  file  /tmp/small/63_nasm_valid

  et  /tmp/small/61_nasm_tiny   ||  echo  "$?"    #  the answer is 42
  et  /tmp/small/63_nasm_valid  ||  echo  "$?"    #  the answer is 42

  et  ls  -n  -B  --color=auto

  return  ;  }


main
