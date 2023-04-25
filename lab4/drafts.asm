%include "../lib/lib64.asm"

section .data
    spaceStr        db ' '
    spaceStrLen     equ $-spaceStr

    newLineStr      db 10
    newLineStrLen   equ $-spaceStr

    inputMatMsg     db   'Enter 7 x 3 elements of matrix separated by a line break:', 10
    inputMatMsgLen  equ  $ - inputMatMsg

    errorMsg        db   'Invalid input', 10
    errorMsgLen     equ  $ - errorMsg

    N               dw  7
    M               dw  3

section .bss
    inputStr        resb  10
    inputStrLen     resw  1
    Matrix          resw  100

section .text
    global _start

_start:
    ; ===== GETTING USER INPUT =====
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
    call printMatrix
    
    jmp exit

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
    mov ecx, dword [N]
    mov esi, 0  ; Row shift
matrix_output_outer_loop:
   
    push rsi
    push rcx
    push rbx
    
    mov ecx, dword [M]
    mov ebx, 0
    matrix_output_inner_loop:
        ; Saving register values, so the wil not be affected by procedure call
        push rax
        push rdi
        push rdx
        ; Convert value from int to string
        movzx eax, word [Matrix + esi + ebx * 2]
        push rsi

        call IntToStr64
break:
        mov edx, eax
        dec edx  ; After calling IntToStr64 EAX contains length of the string in ESI,
                 ; which is terminated with "0xA", that needs to be cut
        inc ebx  ; Increment column index
        
        ; Printing value
        mov rax, 1
        mov rdi, 1
        syscall

        call printSpace

        ; Getting saved values back to register
        pop rsi
        pop rdx
        pop rdi
        pop rax

        loop matrix_output_inner_loop

        pop rbx
        pop rcx
        pop rsi

        add esi, 6

    loop matrix_output_outer_loop