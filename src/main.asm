extern ft_strlen

section .data
    str1 db "Hello", 0
    str2 db "custom", 0

section .text
    global _start

_start:
    mov     rdi, str1
    call    ft_strlen

    mov     rax, 1
    mov     rdi, 1
    mov     rsi, str1
    mov     rdx, 5
    syscall

    mov     rax, 60
    mov     rdi, 0
    syscall