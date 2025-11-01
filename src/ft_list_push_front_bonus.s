; void ft_list_push_front(t_list **begin_list, void *data);

		extern	malloc
		global	ft_list_push_front
		section	.text

ft_list_push_front:
		push	rdi
		push	rsi

		mov		rdi, 16
		xor		rax, rax
		call	malloc wrt ..plt

		pop		rsi
		pop		rdi

		cmp		rax, 0
		jz		.return

		mov		[rax], rsi
		mov		rcx, [rdi]
		mov		[rax + 8], rcx
		mov		[rdi], rax
.return:
		ret
