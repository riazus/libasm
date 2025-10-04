; char* ft_strcpy(char *dst, const char *src)

global ft_strcpy

section .text
; arg1 = rdi, arg2 = rsi
ft_strcpy:
    mov     rax, rdi

.loop:
    cmp     byte [rsi], 0
    je      .done

    mov     dl, [rsi]
    mov     [rdi], dl
    inc     rdi
    inc     rsi
    jmp     .loop

.done:
    ; write the terminator symbol
    mov     byte [rdi], 0
    ret