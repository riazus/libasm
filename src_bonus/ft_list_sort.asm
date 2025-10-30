; void ft_list_sort(t_list **begin_list, int (*cmp)());
		
		global	ft_list_sort
		section	.text

ft_list_sort:
		push	rbx
		push	r12
		cmp		rdi, 0		; begin == NULL
		jz		.restore
		mov		r12, [rdi]	; first = *begin
		cmp		rsi, 0		; cmp == NULL
		jz		.return
		jmp		.compare_main
.increment_main:
		mov		rcx, [rdi]
		mov		rbx, [rbx + 8]
		mov		[rdi], rbx
.compare_main:
		cmp		QWORD [rdi], 0
		jz		.return
		mov		rcx, [rdi]
		mov		rbx, [rcx + 8]
.compare_single:
		cmp		rbx, 0
		jz		.increment_main
.compare:
		push	rdi
		push	rsi
		mov		rcx, [rdi]
		mov		rdi, [rcx]
		mov		rsi, [rbx]
		call	rax			; (*cmp)((*begin)->data, current->data)
		pop		rsi
		pop		rdi
		cmp		rax, 0		; cmp > 0
		jg		.swap
.increment_single:
		mov		rcx, [rbx + 8]
		mov		rbx, rcx
		jmp		.compare_single
.swap:
		mov		r8, [rdi]
		mov		rcx, [r8]
		mov		[r8], rax
		mov		[rbx], rcx
		jmp		.increment_single
.return:
		mov		[rdi], r12	; *begin = first
.restore:
		pop		rbx
		pop		r12
		ret
