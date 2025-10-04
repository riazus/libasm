; ssize_t read(int fildes, void *buf, size_t nbyte);

extern __errno_location

global ft_read

section .text
; arg1 = rdi, arg2 = rsi, arg3 = rdx
ft_read:
    mov   rax, 0
    syscall

    cmp   rax, 0
    js    .error

    ret

.error:
    neg   rax
    mov   rcx, rax

    call  __errno_location wrt ..plt

    mov   [rax], ecx
    mov   rax, -1
    ret
