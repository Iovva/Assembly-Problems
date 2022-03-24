bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
 
; Se dau 2 siruri de octeti A si B. 
; Sa se construiasca sirul R care sa contina doar elementele impare si pozitive din cele 2 siruri.
 
    a db 2, 1, 3, -3 ; declararea sirului initial a
	l1 equ $-a ; stabilirea lungimea sirului initial a
    
    b db 4, 5, -5, 7 ; declararea sirului initial b
	l2 equ $-b ; stabilirea lungimea sirului initial b
    
	d times l1+l2 db 0 ; rezervarea unui spatiu de dimensiune l1+l2 pentru sirul destinatie d si initializarea acestuia
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
    mov EAX, [edi]
    mov EDI, 0 ; EDI - pozitia elementului din sirul destinatie
    mov ESI, 0 ; ESI - pozitia elementului din sirul sursa
    
    mov ECX, l1 ; punem lungimea sirului a in ECX pentru a putea realiza bucla loop de ECX ori
    jecxz Done1 ; daca sirul este nul, sare peste loop
	Repeta1:
    
		mov AL, [a+ESI] 
        
        ; verifica daca elementul este impar:
        test AL, 1
        jz incrementare1
        
        ; verifica daca elementul este pozitiv:
        cmp AL,0
        JL incrementare1 
        
        ; adauga la sirul destinatie elementul, daca este impar si pozitiv
		mov [d+EDI], AL
        inc EDI
        
        ; incrementeaza pozitia elementului din sirul sursa
		incrementare1:
        inc ESI
        
	loop Repeta1
    
	Done1:
    
    
    mov ESI, 0 ; ESI - pozitia elementului din sirul sursa
    
    mov ECX, l2 ; punem lungimea sirului a in ECX pentru a putea realiza bucla loop de ECX ori
    jecxz Done2 ; daca sirul este nul, sare peste loop
	Repeta2:
    
		mov AL, [b+ESI] 
        
        ; verifica daca elementul este impar:
        test AL, 1
        jz incrementare2
        
        ; verifica daca elementul este pozitiv:
        cmp AL,0
        JL incrementare2 
        
        ; adauga la sirul final destinatie, daca este impar si pozitiv
		mov [d+EDI], AL
        inc EDI
        
        ; incrementeaza pozitia elementului din sirul sursa
		incrementare2:
        inc ESI
        
	loop Repeta2
    
	Done2:
    
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
