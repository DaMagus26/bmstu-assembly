%include "../lib/lib64.asm"

section .data
    inputXMsg db 'Enter X:', 10
    inputXMsgLen equ $ - inputXMsg

    inputYMsg db 'Enter Y:', 10
    inputYMsgLen equ $ - inputYMsg

    inputAMsg db 'Enter A:', 10
    inputAMsgLen equ $ - inputAMsg

    errorMsg db 'Invalid input', 10
    errorMsgLen equ $ - errorMsg

    zeroDivisionMsg db 'Error: Zero Division', 10
    zeroDivisionMsgLen equ $ - zeroDivisionMsg
section .bss
    X resw 1
    Y resw 1
    A resw 1
    inputString resb 10
    inputLen equ $-inputString

section .text
    global _start

_start:
    ; input X prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, inputXMsg
    mov rdx, inputXMsgLen
    syscall

    ; read X
    mov rax, 0
    mov rdi, 0
    mov rsi, inputString
    mov edx, inputLen
    syscall
    
    ; casting X to int
    call StrToInt64
    cmp ebx, 0
    jne Error

    mov [X], rax

; input Y prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, inputYMsg
    mov rdx, inputYMsgLen
    syscall

    ; read Y
    mov rax, 0
    mov rdi, 0
    mov rsi, inputString
    mov edx, inputLen
    syscall
    
    ; casting Y to int
    call StrToInt64
    cmp ebx, 0
    jne Error

    mov [Y], rax

    ; Checking if X equals Y
    push rax
    push rdx
    movsx eax, word [X]
    movsx edx, word [Y]
    cmp eax, edx
    je zeroDivisionError
    pop rdx
    pop rax

    ; input A prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, inputAMsg
    mov rdx, inputAMsgLen
    syscall

    ; read A
    mov rax, 0
    mov rdi, 0
    mov rsi, inputString
    mov edx, inputLen
    syscall
    
    ; casting A to int
    call StrToInt64
    cmp ebx, 0
    jne Error

    mov [A], rax

T2D:
    ; decicion
    mov ax, word [X]
    cmp ax, 0
    jg True
    jle False

True:
    mov ax, word [A]
    cwd
    imul word [X]
    
    mov bx, dx
    shl ebx, 16
    mov bx, ax
    mov eax, ebx

    cdq
    imul dword [X]
    mov ebx, edx
    shl rbx, 16
    mov ebx, eax

    mov rdx, rbx
    jmp PrintResult

False:
    mov bx, word [Y]
    sub bx, word [X]

    mov ax, word [A]
    cdq
    idiv bx

    cwde
    cdqe
    mov rdx, rax
    jmp PrintResult

PrintResult:
    call IntToStr64
    mov rdx, rbx

    ; print the result
    mov rax, 1
    mov rdi, 1
    syscall
    jmp Exit

Exit:
    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall

Error:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorMsg
    mov rdx, errorMsgLen
    syscall

    jmp Exit

zeroDivisionError:
    mov rax, 1
    mov rdi, 1
    mov rsi, zeroDivisionMsg
    mov rdx, zeroDivisionMsgLen
    syscall

    jmp Exit