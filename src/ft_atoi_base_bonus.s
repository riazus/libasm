; int ft_atoi_base(char *str, char *base)

        global  ft_atoi_base
        section .text

ft_atoi_base:
        push    rbx         ; (pointer)
        push    rcx         ; (base length)
        push    rdx         ; (current_character)
        push    r8          ; (result)
        push    r9          ; (sign)
        push    r10         ; for tmp values
        push    r11         ; (string pointer)

        mov     rbx, rsi    ; rbx = base pointer
        mov     r11, rdi    ; r11 = str pointer
        xor     r8, r8      ; r8 = result = 0
        mov     r9, 1       ; r9 = sign = 1 (positive)

        call    validate_base
        test    eax, eax    ; Check if base is valid
        jz      .return_zero ; If invalid, return 0

        mov     rcx, rax    ; rcx = base_length (returned from validate_base)
        
        ; Step 2: Skip leading whitespace in str
        call    skip_whitespace
        mov     r11, rax    ; Update str pointer to first non-whitespace
        
        ; Step 3: Handle sign characters
        call    handle_sign
        mov     r11, rax    ; Update str pointer after sign
        ; r9 now contains the sign (1 or -1)
        
        ; Step 4: Convert digits
        call    convert_digits
        
        ; Step 5: Apply sign and return
        imul    r8, r9      ; result *= sign
        mov     eax, r8d    ; Return result in eax (32-bit)
        jmp     .cleanup

.return_zero:
    xor     eax, eax    ; Return 0

.cleanup:
    ; Restore registers
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     rdx
    pop     rcx
    pop     rbx
    ret

; ============================================================================
; Helper function: validate_base
; Input: rbx = base pointer
; Output: eax = base_length if valid, 0 if invalid
; Destroys: rax, rdx, r10
; ============================================================================
validate_base:
    ; Check if base is NULL
    test    rbx, rbx
    jz      .invalid
    
    ; Step 1: Calculate base length
    xor     rax, rax    ; length counter
    mov     r10, rbx    ; temporary pointer
    
.count_loop:
    cmp     byte [r10], 0   ; Check for null terminator
    je      .count_done
    inc     rax             ; Increment length
    inc     r10             ; Move to next character
    jmp     .count_loop
    
.count_done:
    ; Check if length >= 2
    cmp     rax, 2
    jl      .invalid
    
    push    rax         ; Save length
    
    ; Step 2: Check for invalid characters (+, -, whitespace)
    mov     r10, rbx    ; Reset pointer to start of base
    
.check_invalid_chars:
    mov     dl, byte [r10]  ; Load current character
    test    dl, dl          ; Check for null terminator
    jz      .check_duplicates
    
    ; Check for '+' (ASCII 43)
    cmp     dl, '+'
    je      .invalid_pop
    
    ; Check for '-' (ASCII 45)
    cmp     dl, '-'
    je      .invalid_pop
    
    ; Check for whitespace characters
    ; Space (32), Tab (9), Newline (10), Carriage return (13), etc.
    cmp     dl, ' '
    je      .invalid_pop
    cmp     dl, 9       ; Tab
    je      .invalid_pop
    cmp     dl, 10      ; Newline
    je      .invalid_pop
    cmp     dl, 11      ; Vertical tab
    je      .invalid_pop
    cmp     dl, 12      ; Form feed
    je      .invalid_pop
    cmp     dl, 13      ; Carriage return
    je      .invalid_pop
    
    inc     r10         ; Move to next character
    jmp     .check_invalid_chars
    
.check_duplicates:
    ; Step 3: Check for duplicate characters
    ; Outer loop: iterate through each character
    mov     r10, rbx    ; Outer loop pointer
    
.outer_dup_loop:
    mov     dl, byte [r10]  ; Current character
    test    dl, dl          ; Check for end
    jz      .valid          ; If end reached, base is valid
    
    ; Inner loop: check if current character appears later
    mov     rax, r10        ; Inner loop pointer starts after current
    inc     rax
    
.inner_dup_loop:
    mov     dh, byte [rax]  ; Character to compare
    test    dh, dh          ; Check for end
    jz      .next_outer     ; If end reached, no duplicate found
    
    cmp     dl, dh          ; Compare characters
    je      .invalid_pop    ; If equal, duplicate found
    
    inc     rax             ; Move to next character
    jmp     .inner_dup_loop
    
.next_outer:
    inc     r10             ; Move to next character in outer loop
    jmp     .outer_dup_loop
    
.valid:
    pop     rax         ; Restore length
    ret                 ; Return with length in eax
    
.invalid_pop:
    pop     rax         ; Clean up stack
.invalid:
    xor     eax, eax    ; Return 0
    ret

; ============================================================================
; Helper function: skip_whitespace
; Input: r11 = string pointer
; Output: rax = pointer to first non-whitespace character
; Destroys: rax, rdx
; ============================================================================
skip_whitespace:
    mov     rax, r11    ; Start from current position
    
.skip_loop:
    mov     dl, byte [rax]  ; Load current character
    test    dl, dl          ; Check for null terminator
    jz      .skip_done
    
    ; Check if character is whitespace
    cmp     dl, ' '     ; Space
    je      .skip_char
    cmp     dl, 9       ; Tab
    je      .skip_char
    cmp     dl, 10      ; Newline
    je      .skip_char
    cmp     dl, 11      ; Vertical tab
    je      .skip_char
    cmp     dl, 12      ; Form feed
    je      .skip_char
    cmp     dl, 13      ; Carriage return
    je      .skip_char
    
    ; Not whitespace, we're done
    jmp     .skip_done
    
.skip_char:
    inc     rax         ; Move to next character
    jmp     .skip_loop
    
.skip_done:
    ret

; ============================================================================
; Helper function: handle_sign
; Input: r11 = string pointer, r9 = current sign
; Output: rax = pointer after sign characters, r9 = final sign
; Destroys: rax, rdx
; ============================================================================
handle_sign:
    mov     rax, r11    ; Start from current position
    
.sign_loop:
    mov     dl, byte [rax]  ; Load current character
    test    dl, dl          ; Check for null terminator
    jz      .sign_done
    
    cmp     dl, '+'     ; Check for plus sign
    je      .skip_plus
    cmp     dl, '-'     ; Check for minus sign
    je      .handle_minus
    
    ; Not a sign character, we're done
    jmp     .sign_done
    
.skip_plus:
    inc     rax         ; Skip the '+' character
    jmp     .sign_loop
    
.handle_minus:
    neg     r9          ; Flip the sign
    inc     rax         ; Skip the '-' character
    jmp     .sign_loop
    
.sign_done:
    ret

; ============================================================================
; Helper function: convert_digits
; Input: r11 = string pointer, rbx = base, rcx = base_length, r8 = result
; Output: r8 = final result
; Destroys: rax, rdx, r10
; ============================================================================
convert_digits:
    mov     rax, r11    ; Current string position
    
.convert_loop:
    mov     dl, byte [rax]  ; Load current character
    test    dl, dl          ; Check for null terminator
    jz      .convert_done
    
    ; Find character in base
    call    find_char_in_base
    cmp     r10, -1         ; Check if character was found
    je      .convert_done   ; If not found, stop conversion
    
    ; Apply formula: result = result * base_length + digit_value
    imul    r8, rcx         ; result *= base_length
    add     r8, r10         ; result += digit_value
    
    inc     rax             ; Move to next character
    jmp     .convert_loop
    
.convert_done:
    ret

; ============================================================================
; Helper function: find_char_in_base
; Input: dl = character to find, rbx = base pointer
; Output: r10 = index if found, -1 if not found
; Destroys: r10, rdi
; ============================================================================
find_char_in_base:
    xor     r10, r10    ; Index counter
    mov     rdi, rbx    ; Base pointer
    
.find_loop:
    mov     dh, byte [rdi]  ; Load base character
    test    dh, dh          ; Check for null terminator
    jz      .not_found
    
    cmp     dl, dh          ; Compare characters
    je      .found
    
    inc     r10             ; Increment index
    inc     rdi             ; Move to next base character
    jmp     .find_loop
    
.found:
    ret                     ; Return with index in r10
    
.not_found:
    mov     r10, -1         ; Return -1 if not found
    ret
