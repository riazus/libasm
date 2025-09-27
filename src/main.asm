; stdlib functions
extern printf
extern malloc

; libasm functions
extern ft_strlen
extern ft_strcpy

section .data
    fmt_ft_strlen db "%s (%d)", 10, 0
    ftm_ft_strcpy db "Source string -> '%s' | Destination string -> '%s'", 10, 0
    str1 db "Hello", 0
    str2 db "custom", 0

section .text
global main

main:
    push    rbp             ; Preserve base pointer
    mov     rbp, rsp        ; Set up stack frame
    
    ; ------- FT_STRLEN ----------
    ; First example
    mov     rdi, str1
    call    ft_strlen

    mov     rdi, fmt_ft_strlen
    mov     rsi, str1
    mov     rdx, rax
    xor     rax, rax
    call    printf

    ; Second example
    mov     rdi, str2
    call    ft_strlen

    mov     rdi, fmt_ft_strlen
    mov     rsi, str2
    mov     rdx, rax
    xor     rax, rax
    call    printf
    ; ----------------------------

    ; ------- FT_STRCPY ----------

    mov     rdi, str1
    call    ft_strlen
    
    ; RAX points to the length of the str1
    mov     rdi, rax
    inc     rdi
    call    malloc

    ; RAX points to the beginning of the allocated memory
    mov     rdi, rax
    mov     rsi, str1
    call    ft_strcpy

    ; RAX points to the beginning of the copied string
    mov     rdi, ftm_ft_strcpy
    mov     rsi, str1
    mov     rdx, rax
    xor     rax, rax
    call    printf

    ; ----------------------------

    pop     rbp             ; Restore base pointer
    ret