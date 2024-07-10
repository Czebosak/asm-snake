global _render

section .data
    SCREEN_X equ 48
    SCREEN_Y equ 16

    SCREEN_X_BYTES equ SCREEN_X / 4

    SCREEN_SIZE equ SCREEN_X * SCREEN_Y
    ARRAY_SIZE equ SCREEN_SIZE / 4 -2

    screen times ARRAY_SIZE db 0b01010101

    EMPTY_CHAR db ' '
    PLAYER_CHAR db '#'
    FOOD_CHAR db 'o'

    END_LINE db 0x0A

section .text

; Renders the screen in console
_render:
    xor rcx, rcx                ; Clear rcx (index into screen)

.loop:
    mov r8b, byte [screen + rcx]

    mov rax, rcx
    mov rbx, SCREEN_X_BYTES
    div rbx

    cmp rdx, 0                  ; No remainder = new line
    jz .reached_new_line

    jmp .continue_loop          ; Otherwise continue

.reached_new_line:
    mov rsi, END_LINE           ; Load end line character
    push rcx
    call display                ; Print end line character
    pop rcx

.continue_loop:
    mov rax, 4 ; Holds how many 2 bit pairs are remaining
    inc rcx

.loop_bit:
    mov bl, r8b
    and bl, 0b00000011 ; Get last 2 bits

    push rax

    ; Set the character to display based on rax value
    cmp bl, 0b00000000
    je .set_empty_char
    cmp bl, 0b00000001
    je .set_player_char
    cmp bl, 0b00000010
    je .set_food_char

.set_empty_char:
    mov rsi, EMPTY_CHAR
    jmp .continue_loop_bit

.set_player_char:
    mov rsi, PLAYER_CHAR
    jmp .continue_loop_bit

.set_food_char:
    mov rsi, FOOD_CHAR
    jmp .continue_loop_bit

.continue_loop_bit:
    push rcx
    call display
    pop rcx
    pop rax
    jmp .check_if_end_of_bit_loop

.check_if_end_of_bit_loop:
    shr r8b, 2
    dec rax
    jnz .loop_bit
    jmp .loop


; Displays a singular character in console
; Parameters:
;  - rsi: character to display
display:
    mov rax, 1                  ; syscall number for write
    mov rdi, 1                  ; file descriptor 1 (stdout)
    mov rdx, 1                  ; number of bytes to write
    syscall
    ret
