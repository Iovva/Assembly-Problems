bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
;a - byte, b - word, c - double word, d - qword - Interpretare cu semn
;(a+b-c)+(a+b+d)-(a+b)

    a DB 5
    b DW -10
    c DD 30
    d DQ 20

    ; ...

; our code starts here
segment code use32 class=code
    start:
 ;a - byte, b - word, c - double word, d - qword - Interpretare cu semn
 ;(a+b-c)+(a+b+d)-(a+b)   
 
    mov AL, [a] ; AL = 05h
    cbw ; AX = 00 05h
    add AX, [b] ; AX = FF FB h
    cwde ; EAX = FF FF FF FB h
    sub EAX, [c] ; EAX = FF FF FF DD h
    
    push EAX 
    
    mov AL, [a] ; AL = 05 h
    cbw ; AX = 00 05 h
    add AX, [b] ; AX = FF FB h
    cwde ; EAX = FF FF FF FB h 
    cdq ; EDX = FF FF FF FF
        ; EDX : EAX = FF FF FF FF : FF FF FF FB h
    
    mov EBX, dword[d] ; EBX = 00 00 00 14 h
    mov ECX, dword[d+4] ; ECX = 00 00 00 00 here
                   ; ECX:EBX = 00 00 00 00 : 00 00 00 14 h
    
    add EAX,EBX ; EAX = 00 00 00 0F h
    adc EDX,ECX ; EDX = 00 00 00 00 h
    
    mov EBX,EAX ; EBX = 00 00 00 0F h
    mov ECX,EDX ; ECX = 00 00 00 00 h
    
    pop EAX ; EAX = FF FF FF FF DD h
    cdq ; EDX = FF FF FF FF h
        ; EDX : EAX = FF FF FF FF : FF FF FF DD h
    
    add EAX,EBX ; EAX = FF FF FF EC h
    adc EDX,ECX ; EDX = FF FF FF FF h
                ; EDX : EAX = FF FF FF FF : FF FF FF EC h
    mov EBX,EAX ; EBX =FF FF FF EC h
    mov ECX,EDX ; ECX = FF FF FF FF h
    
    mov AL,[a] ; AL = 05 h
    cbw ; AX = 00 05 h
    add AX,[b] ; AX = FF FB h
    cwde ; EAX = FF FF FF FB h
    cdq ; EDX : FF FF FF FF h
        ; EDX : EAX = FF FF FF FF : FF FF FF FB here
    
    sub EBX,EAX ; EBX = FF FF FF F1 h
    sbb ECX,EDX ; ECX = FF FF FF FF h
                ; ECX : EBX = FF FF FF FF : FF FF FF F1 h
    
     
    
    
    
    
    
    
    
    

    

    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
