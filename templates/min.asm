section .text

; Возвращает минимальное из двух переданных значений
; Вызывается с помощью call findMin
; Перед вызовом необходимо положить аргументы в стэк
; Возвращает минимальное значение, которое будет лежать в регистре rax
;
; Пример:
;     push rax
;     push rbx
;     call findMin
;     mov rdi, rax

findMin:
    push rbp
    mov rbp, rsp
    mov rbx, [rbp+24]
    mov rcx, [rbp+16]

    cmp rbx, rcx
    jl findMin_true
    jmp findMin_false
    findMin_true:
        mov rax, rbx
        jmp findMin_epilogue
    findMin_false:
        mov rax, rcx
        jmp findMin_epilogue

    findMin_epilogue:
    mov rsp, rbp
    pop rbp
    ret