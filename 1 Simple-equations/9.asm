bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
;(a*a+b+x)/(b+b)+c*c
; a-word; b-byte; c-doubleword; x-qword - interpretare cu semn

    a DW 6
    b DB 10
    c DD -5
    x DQ -10

    ; ...


; our code starts here
segment code use32 class=code
    start:

;(a*a+b+x)/(b+b)+c*c
; a-word; b-byte; c-doubleword; x-qword - interpretare cu semn  
    mov AX, a
    mov AX, [a] ; AX = 00 06 h
    imul AX ; DX:AX = AX * AX = 00 00 : 00 24 h
    push DX 
    push AX  
    pop EBX ; EBX = 00 00 00 24 h
    
    mov AL, [b] ; AL = 0A h
    cbw ; AX = 00 0A h
    cwde ; EAX = 00 00 00 0A h
    add EAX,EBX ; EAX = 00 00 00 2E h
    cdq ; EDX : EAX = 00 00 00 00 : 00 00 00 2E h
    mov EBX, dword[x] ; EBX = FF FF FF F6 h
    mov ECX, dword[x+4] ; ECX = FF FF FF FF h
                   ; ECX : EBX = FF FF FF FF : FF FF FF F6 h
    
    add EBX, EAX ; EBX = 00 00 00 24 h
    adc ECX, EDX ; ECX = 00 00 00 00 h
                 ; ECX : EBX = 00 00 00 00 : 00 00 00 24 h
    
    
    mov AL, [b] ; AL = 0A h
    add AL, [b] ; AL = 14 h
    cbw ; AX = 00 14 h
    cwde ; EAX = 00 00 00 14 h
    push EAX 
    
    mov EAX, EBX ; EAX = 00 00 00 24 h
    mov EDX, ECX ; EDX = 00 00 00 00 h
    
    pop EBX ; EBX = 00 00 00 14 h
    idiv EBX ; EAX = 00 00 00 01 h
             ; EDX = 00 00 00 10 h
    mov EBX,EAX ; EBX = 00 00 00 01 h
    
    mov EAX, [c] ; EAX = FF FF FF FB h
    imul EAX ; EDX:EAX = 00 00 00 00 : 00 00 00 19 h
    add EAX, EBX ; EAX = 00 00 00 1A h
                 ; EDX : EAX = 00 00 00 00 : 00 00 00 1A h
    adc EDX, 0 
    
    
    

    
    
    
    
    
    
    
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
