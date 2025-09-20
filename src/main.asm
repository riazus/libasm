extern ft_strlen
extern printf

section .data
    fmt db "%s (%d)", 10, 0
    str1 db "Hello", 0
    str2 db "custom", 0

section .text
global main

main:
    push    rbp             ; Preserve base pointer
    mov     rbp, rsp        ; Set up stack frame
    
    ; First example
    mov     rdi, str1
    call    ft_strlen

    mov     rdi, fmt
    mov     rsi, str1
    mov     rdx, rax
    xor     rax, rax
    call    printf

    ; Second example
    mov     rdi, str2
    call    ft_strlen

    mov     rdi, fmt
    mov     rsi, str2
    mov     rdx, rax
    xor     rax, rax
    call    printf

    pop     rbp             ; Restore base pointer
    ret