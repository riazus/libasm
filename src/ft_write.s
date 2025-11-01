; ssize_t write(int fildes, const void *buf, size_t nbyte)

        extern  __errno_location
        global  ft_write
        section .text

; fildes = rdi, buf = rsi, nbyte = rdx
ft_write:
        mov     rax, 1
	    syscall             ; call system write
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
