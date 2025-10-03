; stdlib functions
extern printf
extern malloc

; libasm functions
extern ft_strlen
extern ft_strcpy
extern ft_strcmp
extern ft_write
extern ft_read

section .data
    ; ------- Formatters for printf -------
    fmt_ft_strlen db "%s (%d)", 10, 0
    fmt_ft_strcpy db "Source string -> '%s' | Destination string -> '%s'", 10, 0
    fmt_ft_strcmp db "First string: '%s' | Second string: '%s' | Diff: %d", 10, 0
    ; ----------------------------

    str1 db "Hello", 0
    str2 db "custom", 0

    str1_ft_strlen db "helloa", 0
    str2_ft_strlen db "hello2", 0

    str_ft_write db "Hello from ft_write", 10, 0

section .text
global main

main:
    push    rbp             ; Preserve base pointer
    mov     rbp, rsp        ; Set up stack frame
    
    ; ------- FT_STRLEN ----------
    ; First example
    mov     rdi, str1
    call    ft_strlen

    mov     rdi, fmt_ft_strlen
    mov     rsi, str1
    mov     rdx, rax
    xor     rax, rax
    ;call    printf

    ; Second example
    mov     rdi, str2
    call    ft_strlen

    mov     rdi, fmt_ft_strlen
    mov     rsi, str2
    mov     rdx, rax
    xor     rax, rax
    ;call    printf
    ; ----------------------------

    ; ------- FT_STRCPY ----------

    mov     rdi, str1
    call    ft_strlen
    
    ; RAX points to the length of the str1
    mov     rdi, rax
    inc     rdi
    ;call    malloc

    ; RAX points to the beginning of the allocated memory
    mov     rdi, rax
    mov     rsi, str1
    call    ft_strcpy

    ; RAX points to the beginning of the copied string
    mov     rdi, fmt_ft_strcpy
    mov     rsi, str1
    mov     rdx, rax
    xor     rax, rax
    ;call    printf
    ; ----------------------------

    ; ------- FT_STRCMP ----------
    mov     rdi, str1_ft_strlen
    mov     rsi, str2_ft_strlen
    ;call    ft_strcmp

    ; RAX holds the diff between str1 & str2
    mov     rdi, fmt_ft_strcmp
    mov     rsi, str1_ft_strlen
    mov     rdx, str2_ft_strlen
    mov     rcx, rax
    xor     rax, rax
    ;call    printf
    ; ----------------------------

    ; ------- FT_WRITE ----------
    mov     rdi, str_ft_write
    call    ft_strlen

    mov     rdi, 1
    mov     rsi, str_ft_write
    mov     rdx, rax
    ;call    ft_write
    ; ----------------------------

    ; ------- FT_READ ----------
    mov     rdi, 6
    call    malloc
    mov     rcx, rax

    ; buffer capacity - 6 bytes
    mov     r8, 6
    ; bytes_used count
    mov     rbx, 0
    
.ft_read_loop:
    mov     rdi, 0
    lea     rsi, [rcx+rbx]  ; pointer to next free spot
    mov     rdx, r8
    sub     rdx, rbx
    call    ft_read

    cmp     rax, 0
    je      .done
    js      .error

    
    add     rbx, rax
    cmp     rbx, r8
    jne     .ft_read_loop

    mov     rdi, 1
    mov     rsi, rcx
    mov     rdx, rbx
    call    ft_write
    ; ----------------------------

.error:
    ret

.done:
    pop     rbp             ; Restore base pointer
    ret