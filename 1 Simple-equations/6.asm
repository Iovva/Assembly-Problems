bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

    a DB 5
    b DW 10
    c DD 30
    d DQ 20

; (a+b+c)-(d+d)+(b+c) ; a - byte, b - word;
;			  			c - double word, 
;			  			d - qword	
;			    		unsigned

; our code starts here
segment code use32 class=code
    start:
    
    
    mov AL, [a] ; AL = 05 h
    mov AH, 0 ; AX = 00 05 h
    add AX, [b] ; AX = 00 05h + 00 0Ah = 00 0F h  
    mov BX,AX ; BX = AX = 00 0F h 
    mov EAX, 0 ; EAX = 00 00 00 00 h
    mov AX, BX ; EAX = 00 00 00 0F h
    add EAX, [c] ; EAX = 00 00 00 2D h
    mov EDX, 0 ; EDX:EAX = 00 00 00 00 : 00 00 00 2D h
       
    mov EBX, dword[d] ; EBX = 00 00 00 14 h
    mov ECX, dword[d+4] ; ECX = 00 00 00 00 h
                        ; ECX:EBX = 00 00 00 00 : 00 00 00 14 h
    
    add EBX, dword [d] ; EBX = 00 00 00 28 h
    adc ECX, dword [d+4] ; ECX = 00 00 00 00 h 
                         ;ECX:EBX = 00 00 00 00 : 00 00 00 28 h
    
    sub EAX, EBX ; EAX = 00 00 00 05 h
    sbb EDX, ECX ; EDX = 00 00 00 00 h
                 ; EDX : EAX = 00 00 00 00 : 00 00 00 05 h  
                 
    mov EBX, 0 ; EBX = 00 00 00 00 h
    mov BX, [b] ; BX = 00 0A h 
                ; EBX = 00 00 00 00 0A h
                
    mov ECX, 0 ; ECX = 0 h
               ; ECX:EBX = 00 00 00 00 00: 00 00 00 00 0A h
               
    add EAX, EBX ; EAX = 00 00 00 0F h
    adc EDX, ECX ; EDX = 00 00 00 00 h
                 ; EDX : EAX = 00 00 00 00 : 00 00 00 0F h
     
    
    
    
    
    
    
    
    

    

    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
