; size_t ft_strlen(char *str)

        global ft_strlen
        section .text

; str = rdi
ft_strlen:
        mov     rax, rdi
.loop:
        cmp     byte [rax], 0
        je      .return
        inc     rax
        jmp     .loop
.return:
        sub      rax, rdi
        ret
   