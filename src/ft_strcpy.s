; char* ft_strcpy(char *dst, const char *src)

        global  ft_strcpy
        section .text

; dst = rdi, src = rsi
ft_strcpy:
        mov     rax, rdi
.loop:
        cmp     byte [rsi], 0
        je      .return
        mov     dl, [rsi]
        mov     [rdi], dl
        inc     rdi
        inc     rsi
        jmp     .loop
.return:
        mov     byte [rdi], 0
        ret