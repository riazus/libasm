; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));

		extern	free
		global	ft_list_remove_if
		section	.text

; rdi = begin_list, rsi = data_ref, rdx = (*cmp)(), rcx = (*free_fct)(void *)
ft_list_remove_if:
		push	rbp             ; save rbp (tmp)
		push	rbx             ; save rbx (previous)
		push	r12             ; save r12 (first)
		mov		r12, [rdi]      ; first = *begin
		xor		rbx, rbx        ; previous = NULL
		cmp		rdi, 0          ; begin_list == NULL
		jz		.return
		cmp		rcx, 0          ; free_fct == NULL
        jz      .return
        jmp     .compare_start
.free_elt:
        mov     r8, [rdi]
        mov     rbp, [r8 + 8]
        push    rsi
        push    rdx
        push    rcx
        push    rdi
        mov     rdx, [rdi]
        mov     rdi, [rdx]
        call    rcx             ; (*free_fct)((*begin)->data)
        pop     rdi
        push    rdi
        mov     rdx, [rdi]
        mov     rdi, rdx
        call    free wrt ..plt
        pop     rdi
        pop     rcx
        pop     rdx
        pop     rsi
        mov     [rdi], rbp      ; *begin = tmp
        cmp     rbx, 0          ; previous = NULL
        jnz     .set_previous_next
        mov     r12, rbp        ; first = tmp
        jmp     .compare_start
.set_previous_next:
        mov     [rbx + 8], rbp
        jmp     .compare_start
.compare_null:
        xor     rdi, rsi
        mov     rax, rdi
        jmp     .compare_end
.move_next:
        mov     rbx, [rdi]
        mov     r8, [rbx + 8]
        mov     [rdi], r8
.compare_start:
        cmp     QWORD [rdi], 0  ; *begin == NULL
        jz      .return
        push    rdi
        push    rsi
        push    rdx
        push    rcx
        mov     r8, [rdi]
        mov     rdi, [r8]
        cmp     rdi, 0
        jz      .compare_null
        call    rdx
.compare_end:
        pop     rcx
        pop     rdx
        pop     rsi
        pop     rdi
        cmp     rax, 0
        jz      .free_elt
        jmp     .move_next
.return:
        mov     [rdi], r12
        pop     r12
        pop     rbx
        pop     rbp
        ret
