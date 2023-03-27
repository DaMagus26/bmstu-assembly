%include "../lib/lib64.asm"

section .data
    inputAMsg db 'Enter A:', 10
    inputAMsgLen equ $ - inputAMsg

    inputBMsg db 'Enter B:', 10
    inputBMsgLen equ $ - inputBMsg

    errorMsg db 'Invalid input', 10
    errorMsgLen equ $ - errorMsg
section .bss
    A resw 1
    B resw 1
    inputString resb 10
    inputLen equ $-inputString

section .text
    global _start

_start:
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

; input B prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, inputBMsg
    mov rdx, inputBMsgLen
    syscall

    ; read B
    mov rax, 0
    mov rdi, 0
    mov rsi, inputString
    mov edx, inputLen
    syscall
    
    ; casting B to int
    call StrToInt64
    cmp ebx, 0
    jne Error

    mov [B], rax

    ; calculating


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