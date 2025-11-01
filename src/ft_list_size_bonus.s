; int ft_list_size(t_list *begin_list);
		
		global	ft_list_size
		section	.text

ft_list_size:
		mov		rsi, rdi
		xor		rax, rax	
.loop:
		cmp		rdi, 0
		jz		.return
		mov		rdi, [rdi + 8]
        inc		rax
		jmp		.loop
.return:
		mov		rdi, rsi
		ret
	