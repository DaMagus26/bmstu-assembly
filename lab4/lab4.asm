%include "../lib/lib64.asm"

section .data
    spaceStr        db ' '
    spaceStrLen     equ $-spaceStr

    newLineStr      db 10
    newLineStrLen   equ $-spaceStr

    inputNMsg       db   'Enter number of rows (max 10): '
    inputNMsgLen    equ  $ - inputNMsg

    inputMMsg       db   'Enter number of cols (max 10): '
    inputMMsgLen    equ  $ - inputMMsg

    inputMatMsg     db   'Enter n^2 elements of matrix (rows-wise):', 10
    inputMatMsgLen  equ  $ - inputMatMsg

    errorMsg        db   'Invalid input', 10
    errorMsgLen     equ  $ - errorMsg

section .bss
    inputStr        resb  10
    inputStrLen     resw  1
    N               resw  1
    M               resw  1
    Matrix          resw  100

section .text
    global _start

_start:
    ; ===== GETTING USER INPUT =====
    ; Prompt for N
    mov rax, 1
    mov rdi, 1
    mov rsi, inputNMsg
    mov rdx, inputNMsgLen
    syscall

    ; Input of N
    mov rax, 0
    mov rdi, 0
    mov rsi, inputStr
    mov rdx, inputStrLen
    syscall

    ; conversion of N
    call StrToInt64
    cmp ebx, 0
    jne error
    mov [N], eax
    
    ; Prompt for M
    mov rax, 1
    mov rdi, 1
    mov rsi, inputMMsg
    mov rdx, inputMMsgLen
    syscall

    ; Input of M
    mov rax, 0
    mov rdi, 0
    mov rsi, inputStr
    mov rdx, inputStrLen
    syscall

    ; conversion of M
    call StrToInt64
    cmp ebx, 0
    jne error
    mov [M], eax

    ; Prompt for matrix
    mov rax, 1
    mov rdi, 1
    mov rsi, inputMatMsg
    mov rdx, inputMatMsgLen
    syscall

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


    ; ===== AUXILIARY PROCEDURES =====
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

error:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorMsg
    mov rdx, errorMsgLen
    syscall
    jmp exit

printSpace:
; Saving register values, so the wil not be affected by procedure call
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, 1
    mov rdi, 1
    mov rsi, spaceStr
    mov rdx, spaceStrLen
    syscall
    ret

    ; Getting saved values back to register
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

printNewLine:
    ; Saving register values, so the wil not be affected by procedure call
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, 1
    mov rdi, 1
    mov rsi, newLineStr
    mov rdx, newLineStrLen
    syscall

    ; Getting saved values back to register
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

printMatrix:
    mov ecx, eax
    push rcx

    mov rbx, 0
    mov eax, [Matrix]
matrix_loop:
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
    mov [Matrix + 2 + rbx * 2], eax

    pop rbx 
    inc rbx
   
    pop rcx

    loop matrix_loop