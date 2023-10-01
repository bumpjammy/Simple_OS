print_hex:
    pusha             ; Push all registers onto the stack
    mov cx, 4         ; Set cx to 4 (loop 4 times for 4 hex chars)

.repeat:
    dec cx            ; Decrement cx

    mov ax, dx        ; Copy dx to ax
    shr dx, 4         ; Shift dx 4 to the right
    and ax, 0xf       ; Get last 4 bits

    mov bx, .HEX_OUT  ; Set bx to our template string
    add bx, 2         ; Skip first 2 characters ('0x')
    add bx, cx        ; Add cx (our counter, get current character)

    cmp ax, 0xa       ; Check if we are a number or a letter
    jl .set_letter    ; If we are a number, just set it
    add al, 0x27      ; Add 27 if we are a letter
                      ; We add another 30 later
                      ; This gets us to the ascii set of letters
    jl .set_letter

.set_letter:
    add al, 0x30      ; Get us to the correct ascii point
    mov byte[bx], al  ; Add the value of the byte to the character

    cmp cx, 0         ; Check if we are finished
    je .done          ; If the counter is 0, we are done
    jmp .repeat       ; Otherwise, move to the next character

.done:
    mov bx, .HEX_OUT  ; Move our updated hex string into bx
    call println      ; println our hex strijg

    popa              ; pop old registers back in
    ret

.HEX_OUT: db '0x0000', 0
