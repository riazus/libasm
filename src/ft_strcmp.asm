; int strcmp(const char *s1, const char *s2);

global ft_strcmp

section .text
; arg1 = rdi, arg2 = rsi
ft_strcmp:

.loop:
    mov   al, [rdi]
    mov   dl, [rsi]

    ; if they are not equal, return %rax
    cmp   al, dl
    jne    .done_diff
    
    ; compare only %al for end of string 
    ; we compare only one register because they are equal
    cmp   al, 0
    je   .done

    ; increase registers
    inc   rdi
    inc   rsi
    
    ; keep moving through the loop
    jmp   .loop

.done_diff:
    movzx eax, al
    movzx edx, dl
    sub   eax, edx
    ret

.done:
    mov   rax, 0
    ret
