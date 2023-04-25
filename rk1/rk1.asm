%include "../lib/lib.asm"

section .data
B dw 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
H dw 1, 1, 1, 1, 1, 1
newLine db 10

section .text
global _start

_start:
    mov ebx, B
    mov esi, 0
    mov ecx, 6

.next_row:
    ; Вычисление произведения главной диагонали
    mov edi, esi
    mov eax, 1
    .gd_loop:
        mov edx, [ebx + edi*2]
        imul eax, edx
        add edi, 7

        cmp edi, 36
        jl .gd_loop

    ; Сохранение результата
    mov [H + esi*2], eax

    ; Вычисление произведения побочной диагонали
    mov edi, dword [esi * 5]
    mov eax, 1
    .pd_loop:
        mov edx, [ebx + edi*2]
        imul eax, edx
        sub edi, 5

        cmp edi, 0
        jge .pd_loop

    ; Обновление результата с учетом произведения побочной диагонали
    mov edx, [H + esi*2]
    imul eax, edx
    mov [H + esi*2], eax

    inc esi
    cmp esi, ecx
    jne .next_row

    ; вывод
    mov ecx, 6
    mov ebx, 0
.print_loop:
    mov eax, [H + ebx*2]

    mov esi, OutBuf
    call IntToStr
    call print_num
    call print_nl

    inc ebx
    cmp ebx, ecx
    jne .print_loop

call exit

exit:
    mov eax, 1
    xor ebx, ebx
    int 80h

print_num:
    mov eax, 1
    mov ebx, 1
    mov ecx, OutBuf
    mov edx, LenOut

    int 80h

print_nl:
    mov eax, 1
    mov ebx, 1
    mov ecx, newLine
    mov edx, 1

    int 80h

section .bss
    OutBuf resb 4
    LenOut equ $-OutBuf
