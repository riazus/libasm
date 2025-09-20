; size_t ft_strlen(char *str)

global ft_strlen

section .text
ft_strlen:
    mov     rax, rdi
.loop:
    cmp     byte [rax], 0
    je      .done
    inc     rax
    jmp     .loop
.done:
    sub     rax, rdi
    ret
