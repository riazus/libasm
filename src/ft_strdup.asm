; char *strdup(const char *s1);

extern malloc
extern printf
extern __errno_location

extern ft_strlen
extern ft_strcpy

global ft_strdup

section .text
ft_strdup:
    mov     rbx, rdi        ; save string pointer to use later
    call    ft_strlen

    mov     r12, rax        ; save string length

    ; allocate buffer (len + 1)
    inc     r12
    mov     rdi, r12
    call    malloc wrt ..plt
    mov     r12, rax

    test    r12, r12
    je      .error

    ; copy into allocated buffer
    mov     rdi, r12        ; dest
    mov     rsi, rbx        ; src (original input)
    call    ft_strcpy

    ret

.error:
    ; Set errno = ENOMEM and return NULL
    call    __errno_location wrt ..plt
    mov     dword [rax], 12     ; ENOMEM
    xor     rax, rax
    ret

