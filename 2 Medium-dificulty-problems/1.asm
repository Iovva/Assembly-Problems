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

; Se da cuvantul A. Sa se obtina numarul intreg n reprezentat de bitii 0-2 ai lui A. 

; Sa se obtina apoi in B cuvântul rezultat prin rotirea spre dreapta (fara carry) a lui A cu n pozitii.

; Sa se obtina dublucuvantul C:
; bitii 8-15 ai lui C sunt 0
; bitii 16-23 ai lui C coincid cu bitii lui 2-9 ai lui B
; bitii 24-31 ai lui C coincid cu bitii lui 7-14 ai lui A
; bitii 0-7 ai lui C sunt 1
          
    
  a dw 0111011101011101b ; 0111 0111 0101 1101b
  n resw 1
  b resw 1
  c resd 1
  
; our code starts here
segment code use32 class=code
    start:

; Se da cuvantul A. Sa se obtina numarul intreg n reprezentat de bitii 0-2 ai lui A.
      
        
        mov AX, [a] ; AX = 0111 0111 0101 1101 b
        and AX, 0000000000000111b ; AX = 0000 0000 0000 0101 b  (operatia de izolare)
        
        mov [n], AX ;  n - numarul intreg reprezentat de bitii 0-2 ai lui A.
                    ;  n - 0000 0000 0000 0101 b ( = 5 )
        
;-------------------------------------------------------
 
; Sa se obtina apoi in B cuvântul rezultat prin rotirea spre dreapta (fara carry) a lui A cu n pozitii.
 
 
        mov AX, [a] ; AX = 0111 0111 0101 1101 b
        mov CL, [n] ; CL = 5
        ror AX, CL  ; AX = 1011 1011 1010 1110 b
                    ; AX = 0101 1101 1101 0111 b
                    ; AX = 1010 1110 1110 1011 b
                    ; AX = 1101 0111 0111 0101 b
                    ; AX = 1110 1011 1011 1010 b
        
        mov [b], AX ; b - cuvântul rezultat prin rotirea spre dreapta (fara carry) a lui A cu n (5) pozitii
                    ; b - 1110 1011 1011 1010 b
                    
;---------------------------------------------------------     
        
; Sa se obtina dublucuvantul C:
; bitii 8-15 ai lui C sunt 0
; bitii 16-23 ai lui C coincid cu bitii lui 2-9 ai lui B
; bitii 24-31 ai lui C coincid cu bitii lui 7-14 ai lui A
; bitii 0-7 ai lui C sunt 1
        
        
        ; bitii 0-7 ai lui C sunt 1
        or EAX, 00000000000000000000000011111111b ; EAX = 0000 0000 0000 0000 0000 0000 1111 1111 b
        
        ; bitii 8-15 ai lui C sunt 0
        and EAX, 11111111111111110000000011111111b ; EAX = 0000 0000 0000 0000 0000 0000 1111 1111 b
        

        ; bitii 16-23 ai lui C coincid cu bitii lui 2-9 ai lui B
        mov EDX, [b] ; EDX = 0000 0000 0000 0000 1110 1011 1011 1010 b
        and EDX, 00000000000000000000001111111100b ; EDX = 0000 0000 0000 0000 0000 0011 1011 1000 b
        mov CL, 14
        rol EDX, CL ; EDX = 0000 0000 1110 1110 0000 0000 0000 0000 b
        or EAX, EDX ; EAX = 0000 0000 1110 1110 0000 0000 1111 1111 b
        
        ; bitii 24-31 ai lui C coincid cu bitii lui 7-14 ai lui A
        mov EDX, [a] ; EDX = 0000 0000 0000 0000 0111 0111 0101 1101b b
        and EDX, 00000000000000000111111110000000b ; EDX = 0000 0000 0000 0000 0111 0111 0000 0000
        mov CL, 17
        rol EDX, CL ; EDX = 1110 1110 0000 0000 0000 0000 0000 0000 b
        or EAX, EDX ; EAX = 1110 1110 1110 1110 0000 0000 1111 1111 b
        
        mov [c], EAX ; c - 1110 1110 1110 1110 0000 0000 1111 1111 b
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
