global _start
section .data
	hash: db "#"
	space: db " "
	
	clear: db 27,"[H",27,"[2J"
	clen: equ $ - clear

	timeval:
		tv_sec  dq 1	; seconds
		tv_nsec dq 0	; nanoseconds

section .text

; making the first half of printing more convienient
print_sr:
	mov rax, 1
	mov rdi, 1
 	ret

clear_screen:
	call print_sr
	mov rsi, clear
	mov rdx, clen
	syscall
	ret

reset_counter:
	mov r8, 1
	ret

; function to print r8 number of spaces
print_spaces:
	mov r9, 0
loop:	
	call print_sr
	mov rsi, space
	mov rdx, 1
	syscall	

	inc r9
	cmp r9, r8
	jne loop
	ret

; - - - - - - - - - - - - - - - - - 

_start:
	call clear_screen
	call reset_counter

mainloop:

	call print_spaces	
	
	call print_sr
	mov rsi, hash
	mov rdx, 1
	syscall

	; wait here for n seconds
	mov rax, 35	; sys_nanosleep
	mov rdi, timeval
	xor rsi, rsi
	syscall

	call clear_screen

	inc r8
	cmp r8, 10
	jne mainloop

	call reset_counter
	jmp mainloop

	; exit
	mov rax, 60
	mov rdi, 0
	syscall	
