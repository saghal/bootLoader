
[bits 16]           ; meaning only the 16 bit registers are available and assembler is working in 16-bit
[org 0x7c00]        ; BIOS will load us from 0x7C00 memory location

start:              					; start label from where our code starts
    mov si, hello_world             	   		; Pointing first character of hello_world string to source index(si) register  
    call print_string                      		; call print_string function
    hello_world db  'Hello World!',13,0	; define string and initialize that


print_string:			 ; label of print string 	
    mov ah, 0x0E                 ;  To print a character we use service 0x0E,this service tell to interrupt handler take ASCII character from al and print that character by 0x10 

.repeat_next_char:		 ; label of interrupt loop
    lodsb               	 ; lodsb load a character in al and  si is incremented
    cmp al, 0                    ; compare al with '\0' to know this character end of string or no
    je .done_print               ; if char is zero, end of string and run done print
    int 0x10                     ; if char not 0 print char
    jmp .repeat_next_char        ; jump to .repeat_next_char 

.done_print:
    ret                          ;return

    times (510 - ($ - $$)) db 0x00    				   ; Fill the rest of the sector with zeros(1 sector equal with 512 bytes)
    dw 0xAA55                                                      ; boot signature ,fill last 2 byte by this magic numbers 0xAA , 0x55 for identify bootloader
