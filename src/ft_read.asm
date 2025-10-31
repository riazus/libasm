; ssize_t read(int fildes, void *buf, size_t nbyte);

        extern  __errno_location
        global  ft_read
        section .text

; fildes = rdi, buf = rsi, nbyte = rdx
ft_read:
        mov     rax, 0
        syscall             ; call system read
        cmp     rax, 0
        js      .error
        ret
.error:
        neg     rax
        mov     rcx, rax
        call    __errno_location wrt ..plt
        mov     [rax], ecx
        mov     rax, -1
        ret
