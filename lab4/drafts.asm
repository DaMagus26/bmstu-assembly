; %include "../lib/lib64.asm"

; section .data
;     inputNMsg       db   'Enter number of rows (max 10): '
;     inputNMsgLen    equ  $ - inputNMsg

;     inputMMsg       db   'Enter number of cols (max 10): '
;     inputMMsgLen    equ  $ - inputMMsg

;     inputMatMsg     db   'Enter n^2 elements of matrix (rows-wise):', 10
;     inputMatMsgLen  equ  $ - inputMatMsg

;     errorMsg        db   'Invalid input', 10
;     errorMsgLen     equ  $ - errorMsg

; section .bss
;     inputStr        resw  10
;     inputStrLen     resw  1
;     N               resw  1
;     M               resw  1
;     Matrix          resw  100

; section .text
;     global _start

; _start:
;     ; Prompt for N
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, inputNMsg
;     mov rdx, inputNMsgLen
;     syscall

;     ; Input of N
;     mov rax, 0
;     mov rdi, 0
;     mov rsi, inputStr
;     mov rdx, inputStrLen
;     syscall

;     ; conversion of N
;     call StrToInt64
;     cmp ebx, 0
;     jne error
;     mov [N], eax
    
;     ; Prompt for M
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, inputMMsg
;     mov rdx, inputMMsgLen
;     syscall

;     ; Input of M
;     mov rax, 0
;     mov rdi, 0
;     mov rsi, inputStr
;     mov rdx, inputStrLen
;     syscall

;     ; conversion of M
;     call StrToInt64
;     cmp ebx, 0
;     jne error
;     mov [M], eax

;     ; Prompt for matrix
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, inputMatMsg
;     mov rdx, inputMatMsgLen
;     syscall

;     ; Populating matrix
;     mov ax, [N]
;     mul word [M]
;     mov ecx, eax
;     push rcx

;     mov rbx, 0
;     mov eax, [Matrix]
; matrix_loop:
;     ; print the result
;     push rcx

;     mov rax, 0
;     mov rdi, 0
;     mov rsi, inputStr
;     mov rdx, inputStrLen
;     syscall

;     push rbx

;     call StrToInt64
;     cmp ebx, 0
;     jne error
;     mov [Matrix + 2 + rbx * 2], eax

;     pop rbx 
;     inc rbx
   
;     pop rcx

;     loop matrix_loop

;     ; printing matrix
;     pop rcx
;     mov rbx, 0
;     mov eax, [Matrix]
; matrix_loop_print:
;     push rcx
;     push rbx

;     mov eax, [Matrix + 2 + rbx * 2]
;     call IntToStr64
; break:
;     mov rdx, rax

;     mov rax, 1
;     mov rdi, 1
;     syscall

;     pop rbx 
;     inc rbx
;     pop rcx

;     loop matrix_loop_print

; exit:
;     ; exit
;     mov rax, 60,
;     xor rdi, rdi
;     syscall

; error:
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, errorMsg
;     mov rdx, errorMsgLen
;     syscall
;     jmp exit

%include "../lib/lib64.asm"

section .data
	Space db " "
	NewLine: db 0xA
	
	StartMsg db "Input matrix looks following: ", 0xA
	lenStart equ $-StartMsg
	
	ProMsg db "Processed matrix looks following: ", 0xA
	lenPro equ $-ProMsg
	
	ResMsg db "The number of the row: ", 0xA
	lenRes equ $-ResMsg
	
	InputMsg db "Input matrix: ", 0xA 
	lenInput equ $-InputMsg
	
	InputLineMsg db "Input element of the line one by one: ", 0xA
	lenLineInput equ $-InputLineMsg

section .bss
	matrix resd 100
	
	OutBuf resb 2 
	lenOut equ $-OutBuf
	
	InBuf resd 2
	lenIn equ $-InBuf
			
section .text ; сегмент кода
global _start
_start:

	; --------------------- Ввод матрицы
	call PrintInputMsg
	call PrintInputLineMsg
	
	mov rbx, 0 
	mov rcx, 7 
	cycleInput1:
		push rcx
		mov rcx, 3 
		mov rsi, 0 
		cycleInput2:
			push rcx 
			push rsi 
			push rbx
			
			call InputNumber
			mov rdi, InBuf
			call StrToInt64
			cmp rbx, 0
			jne 0
			pop rbx 
			pop rsi
			mov [rbx + rsi + matrix], rax 
			
			add rsi, 4
			pop rcx
			loop cycleInput2
			
		call PrintInputLineMsg
		pop rcx
		add rbx, 12
		dec rcx
		jnz cycleInput1
	
	
	; --------------------- Вывод матрицы
	mov rax, 1
	mov rdi, 1
	mov rsi, StartMsg 
	mov rdx, lenStart
	syscall
	
	mov rbx, 0 
	mov rcx, 7 
	cyclePrint1:
		push rcx
		mov rcx, 3 
		mov rsi, 0 
		cyclePrint2: 
			push rcx
			push rsi
			mov rax, [rbx + rsi + matrix]
			mov rsi, OutBuf
			call IntToStr64
			call PrintNumber
			call PrintSpace
			pop rsi
			pop rcx
			add rsi, 4
			loop cyclePrint2
		call PrintNewLine
		pop rcx
		add rbx, 12 
		dec rcx
		jnz cyclePrint1

	
	
	; --------------------- Обработка
	mov rbx, 0 
	mov rcx, 7 
	mov rdx, 0 
	mov r8, 0 
	cycle1:
		mov r8, rcx
		push rcx
		mov rcx, 3 
		mov rsi, 0 
		mov rax, 0 
		cycle2:
			mov rax, 0
			add rax, rcx
			add rax, r8
			mov r10, 2
			cwd
			idiv r10
			
			cmp rdx, 0
			jne notZero
			
			mov dword[rbx + rsi + matrix], 0
			add eax, [rbx + rsi + matrix]
			jmp notZeroContinue
			
			notZero:
			add eax, [rbx + rsi + matrix]
			
			notZeroContinue:
			
			add rsi, 4 
			loop cycle2 
		
		pop rcx
		cmp rax, rdx
		jl big_rsp 
		mov rdx, rax
		mov r8, rcx
		jmp continue
	
	big_rsp:
		pop rcx 

	continue:
		add rbx, 12 
		dec rcx
		jnz cycle1 
    
    
	; --------------------- Вывод матрицы
	mov rax, 1
	mov rdi, 1
	mov rsi, ProMsg 
	mov rdx, lenPro
	syscall
	
	mov rbx, 0 
	mov rcx, 7 
	cyclePrint1_1:
		push rcx 
		mov rcx, 3 
		mov rsi, 0 
		cyclePrint2_1: 
			push rcx
			push rsi
			mov rax, [rbx + rsi + matrix]
			mov rsi, OutBuf
			call IntToStr64
			call PrintNumber
			call PrintSpace
			pop rsi
			pop rcx
			add rsi, 4
			loop cyclePrint2_1
		call PrintNewLine
		pop rcx
		add rbx, 12
		dec rcx
		jnz cyclePrint1_1
		
	exit:
		mov rax, 60; системная функция 60 (exit)
		xor rdi, rdi; return code 0
		syscall; вызов системной функции
		
	PrintInputMsg:
		mov rax, 1
		mov rdi, 1
		mov rsi, InputMsg
		mov rdx, lenInput
		syscall
		ret
		
	PrintInputLineMsg: 
		mov rax, 1
		mov rdi, 1
		mov rsi, InputLineMsg
		mov rdx, lenLineInput
		syscall
		ret
		
	PrintSpace:
		mov rax, 1
		mov rdi, 1
		mov rsi, Space
		mov rdx, 1
		syscall
		ret
		
	PrintNumber:
		mov rax, 1
		mov rdi, 1
		mov rsi, OutBuf
		mov rdx, lenOut
		syscall
		ret
		
	PrintNewLine:
		mov rax, 1
		mov rdi, 1
		mov rsi, NewLine
		mov rdx, 1
		syscall
		ret
		
	InputNumber:
		mov rax, 0
		mov rdi, 0
		mov rsi, InBuf 
		mov rdx, lenIn 
		syscall
		ret


		; Populating matrix
    mov ax, [N]
    mul word [M]
    cwde
    cdqe
    mov rcx, rax
    push rcx  ; saving rcx for future use in print loop

    mov rbx, 0
matrix_input_loop:
    ; print the result
    push rcx

    mov rax, 0
    mov rdi, 0
    mov rsi, inputStr
    mov rdx, inputStrLen
    syscall

    push rbx

    call StrToInt64
    cmp ebx, 0
    jne error

    pop rbx 
    mov [Matrix + rbx * 2], eax
    inc rbx
   
    pop rcx
    loop matrix_input_loop

    ; printing matrix
    pop rcx  ; retrieving rcx, that was saved before first loop  // TODO save rcx in a separate variable
    mov rbx, 0
matrix_output_loop:
    push rcx
    ; push rbx

    mov eax, [Matrix + rbx * 2]
    call IntToStr64
break:
    mov rdx, rax

    mov rax, 1
    mov rdi, 1
    syscall

    ; pop rbx 
    inc rbx
    pop rcx

    loop matrix_output_loop