; int strcmp(const char *s1, const char *s2);

        global ft_strcmp
        section .text

; s1 = rdi, s2 = rsi
ft_strcmp:

.loop:
        mov     al, [rdi]
        mov     dl, [rsi]
        cmp     al, dl          ; if they are not equal, return %rax
        jne     .done_diff
        cmp     al, 0
        je      .done
        inc     rdi
        inc     rsi
        jmp     .loop
.done_diff:
        movzx   eax, al         ; move with zero-extend
        movzx   edx, dl
        sub     eax, edx
        ret
.done:
        mov     rax, 0
        ret
