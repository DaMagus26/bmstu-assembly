; Дан текст, состоящий из слов, разделенных несколькими пробелами.
; Определить количество согласных букв в каждом слове и количество гласных во всем тексте.

%include "../lib/lib64.asm"
%assign BUFFER_LEN 50

section .data
; Служебные строки
    colon                db ':'
    space                db ' '
    new_line             db 10
    vowels               db 'aeoui'
    vowelsLen            equ $-vowels

; Строки взаимодействия с пользователем
    inputPrompt          db 'Enter a string:', 10
    inputPromptLen       equ $-inputPrompt

    wordsConsonants      db 'Consonants in each word:', 10
    wordsConsonantsLen   equ $-wordsConsonants

    totalVowels          db 'Total number of vowels in the string ', 10
    totalVowelsLen       equ $-totalVowels

section .bss
    word_begin           resb 1
    word_len             resw 1
    word_consonants      resw 1
    total_vowels         resw 1
    inputBuffer          resb BUFFER_LEN
    inputBufferLen       equ  BUFFER_LEN

section .text
global _start

_start:
    ; Запрос на ввод строки
    mov rax, 1
    mov rdi, 1
    mov rsi, inputPrompt
    mov rdx, inputPromptLen
    syscall

    ; Считывание ввода
    mov rax, 0
    mov rdi, 0
    mov rsi, inputBuffer
    mov rdx, inputBufferLen
    syscall

    ; Вычисление длины строки до Enter
    lea rdi, qword [inputBuffer]
    mov rcx, BUFFER_LEN
    mov al, byte [new_line]
    repne scasb
    mov rax, BUFFER_LEN
    sub rax, rcx
    mov rcx, rax

    mov byte[rcx+inputBuffer-1], ' '
    
    ; Вычисление числа согласных для всех слов строки
    lea rsi, [inputBuffer-1]
    mov rdx, 0  ; Счетчик гласных
    mov rbx, 0  ; Счетчик согласных
    mov [word_begin], rsi  ; Адрес начала слова. Будет использоваться в дальнейшем для вывода этого слова
    cld

master_loop:    ; Цикл обхода по всем символам строки
    lodsb       ; Копируем символ в RAX для последующей проверки
    cmp rax, ' '
    je ms_isSpace
    jmp ms_isntSpace

    ms_isSpace:
        mov r8, rsi
        sub r8, [word_begin]
        dec r8

        ; Вывод рассмотренного слова
        push rax
        push rdi
        push rsi
        push rdx

        mov rax, 1
        mov rdi, 1
        mov rsi, [word_begin]
        mov rdx, r8
        syscall

        call printColon
        call printSpace

        ; Вывод числа согласных
        mov rax, rbx
        call IntToStr64
        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        syscall

        pop rdx
        pop rsi
        pop rdi
        pop rax

        mov [word_begin], rsi
        loop master_loop
    ms_isntSpace:
        ; ...
        loop master_loop
    
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; ============= Вспомогательные функции =============
printNL:   ; вывод новой строки
        push rax
        push rdi
        push rsi
        push rdx
        
        mov rax, 1
        mov rdi, 1
        mov rsi, new_line
        mov rdx, 1
        syscall

        pop rdx
        pop rsi
        pop rdi
        pop rax
        
        ret

printSpace:   ; вывод пробела
        push rax
        push rdi
        push rsi
        push rdx
        
        mov rax, 1
        mov rdi, 1
        mov rsi, space
        mov rdx, 1
        syscall

        pop rdx
        pop rsi
        pop rdi
        pop rax
        
        ret

printColon:   ; вывод двоеточия
        push rax
        push rdi
        push rsi
        push rdx
        
        mov rax, 1
        mov rdi, 1
        mov rsi, colon
        mov rdx, 1
        syscall

        pop rdx
        pop rsi
        pop rdi
        pop rax
        ret