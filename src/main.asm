bits 64
global _start

extern _render

section .text
_start:
    mov rsi, "a"
    call _render

exit:
    mov rax, 60         ; syscall nubmer for exit
    xor rdi, rdi        ; Error code 0
    syscall

