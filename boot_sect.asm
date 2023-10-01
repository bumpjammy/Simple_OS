[org 0x7c00]

start:
    mov [BOOT_DRIVE], dl     ; Boot drive is stored in dl, so read it and store it

    mov bp, 0x8000           ; Set stack address away from boot sector
    mov sp, bp               ; Ensures we avoid overwrites

    mov bx, 0x9000           ; Load 5 sectors (0x0000 -> 0x9000)
    mov dh, 5                ; from boot disk
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov dx, [0x9000]         ; Print out the first loaded word (should be 0xfade)
    call print_hex

    mov dx, [0x9000 + 512]   ; Print out the second loaded word (should be 0xface)
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

times 256 dw 0xfade          ; Add random data to check that we can actually read it
times 256 dw 0xface