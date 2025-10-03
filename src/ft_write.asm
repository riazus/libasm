; ssize_t write(int fildes, const void *buf, size_t nbyte)

extern __errno_location

global ft_write

section .text
; arg1 = rdi, arg2 = rsi, arg3 = rdx
ft_write:
    mov   rax, 1
    syscall
    
    cmp   rax, 0
    js    .error

    ret

.error:
    neg   rax
    mov   rcx, rax

    call  __errno_location

    mov   [rax], ecx
    mov   rax, -1
    ret