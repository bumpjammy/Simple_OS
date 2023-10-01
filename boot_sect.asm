[org 0x7c00]

start:
    mov [BOOT_DRIVE], dl

    mov bp, 0x8000
    mov sp, bp

    mov bx, 0x9000
    mov dh, 5
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov dx, [0x9000]
    call print_hex

    mov dx, [0x9000 + 512]
    call print_hex

    hlt                      ; Halt CPU (more efficient than jmp $)

%include "text_handler.asm"
%include "hex_handler.asm"
%include "data_reader.asm"

; Global variables
BOOT_DRIVE:
    db 0

times 510-($-$$) db 0        ; Pads to 510 bytes - boot sector must be 512 bytes
dw 0xaa55                    ; Adds boot signature for BIOS to know this is a boot sector

times 256 dw 0xfade
times 256 dw 0xface