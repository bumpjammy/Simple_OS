println:
    pusha             ; Push all registers onto the stack
    call print        ; Call the print function to print the text
    mov bx, .NEWLINE  ; Then print a new line
    call print
    popa              ; Pop all registers back from stack
    ret

.NEWLINE:
    db 13, 10, 0      ; Ascii codes for new line then null-termination

print:
    pusha             ; Push all registers onto the stack

.repeat:              ; Loop for each character
    mov al, [bx]      ; Move the byte stored at bx into al
    cmp al, 0         ; Check if it is 0
    jne .print_char   ; If not, print the character

    popa              ; Pop all registers back from stack
    ret

.print_char:          ; Print each character
    mov ah, 0x0e      ; Set BIOS to correct mode
    int 0x10          ; Interrupt to print character
    add bx, 1         ; Add 1 to bx - Move forwards in memory
    jmp .repeat       ; Repeat