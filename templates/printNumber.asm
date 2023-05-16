%include "../lib/lib64.asm"

section .text

printNumber:
    push rbp
    mov rbp, rsp
    mov rax, [rbp+16]

    call IntToStr64
    mov rdx, rax  ; Сохранение длины строки, возвращенной IntToStr64 в rdx
    mov rax, 1
    mov rdi, 1

    printNumber_epilogue:
    mov rsp, rbp
    pop rbp
    ret