bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
;(a*a+b+x)/(b+b)+c*c
; a-word; b-byte; c-doubleword; x-qword - interpretare fara semn

    a DW 6
    b DB 10
    c DD 5    
    x DQ 10    

    ; ...


; our code starts here
segment code use32 class=code
    start:

;(a*a+b+x)/(b+b)+c*c
; a-word; b-byte; c-doubleword; x-qword - interpretare fara semn  
	mov EAX, 0
    mov AX, [a] ; AX = 00 06 h
    imul AX ; DX:AX = AX * AX = 00 00 : 00 24 h
    push word[EAX] 
    push AX  
    pop EAX ; EAX = 00 00 00 24 h
    mov EBX, EAX ; EBX = 00 00 00 24 h
    

    mov EAX,0 ; EAX = 00 00 00 00 h
    mov AL, [b] ; AL = 0A h
                ; EAX = 00 00 00 0A h
    add EAX,EBX ; EAX = 00 00 00 2E h
    
    mov EDX, 0 ; EDX = 00 00 00 00 h
               ; EDX : EAX = 00 00 00 00 : 00 00 00 2E h
               
    mov EBX, dword[x] ; EBX = 00 00 00 0A h
    mov ECX, dword[x+4] ; ECX = 00 00 00 00 h
                   ; ECX : EBX = 00 00 00 00 : 00 00 00 0A h
    
    add EBX, EAX ; EBX = 00 00 00 38 h
    adc ECX, EDX ; ECX = 00 00 00 00 h
                 ; ECX : EBX = 00 00 00 00 : 00 00 00 38 h
    
    
    mov EAX, 0 ; EAX = 00 00 00 00 h
    add AL, [b] ; AL = 0A h
                ; EAX = 00 00 00 0A h
    add AL, [b] ; AL = 14 h
                ; EAX = 00 00 00 14 h 
                
    push EAX 
    
    mov EAX, EBX ; EAX = 00 00 00 38 h
    mov EDX, ECX ; EDX = 00 00 00 00 h
                 ; EDX:EAX = 00 00 00 00 : 00 00 00 38 h
                 
    pop EBX ; EBX = 00 00 00 14 h
    
    div EBX ; EAX = 00 00 00 02 h
             ; EDX = 00 00 00 10 h
    mov EBX,EAX ; EBX = 00 00 00 02 h
    
    mov EAX, [c] ; EAX = 00 00 00 05 h
    mul EAX ; EDX:EAX = 00 00 00 00 : 00 00 00 19 h
    add EAX, EBX ; EAX = 00 00 00 1B h
                 ; EDX:EAX = 00 00 00 00 : 00 00 00 1B h
    
    
    

    
    
    
    
    
    
    
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
