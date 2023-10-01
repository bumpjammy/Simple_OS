disk_load:
    push dx                     ; Push dx to the stack to restore later

    mov ah, 0x02                ; Function to read sectors (BIOS)
    mov al, dh                  ; Read DH Sectors
    mov ch, 0x00                ; Cylinder 0
    mov dh, 0x00                ; Head 0
    mov cl, 0x02                ; Sector 2 (After boot sector)

    int 0x13                    ; BIOS interrupt (read data)

    jc .disk_error              ; Jump if error (if carry flag is set)

    pop dx                      ; Restore dx from stack
    cmp dh, al                  ; If the sectors read (AL) != the sectors expected (DH)
    jne .disk_error             ; Display error
    ret

.disk_error:
    mov bx, .DISK_ERROR_MSG
    call println
    jmp $

.DISK_ERROR_MSG:
    db "Disk read error.", 0