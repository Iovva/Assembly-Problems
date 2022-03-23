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

;  (50-b-c)*2+a*a+d  ; a, b, c- byte, 
;		       		   d – word

a DB 6
b DB 3
c DB 2
d DW 10

    
; our code starts here
segment code use32 class=code
    start:
    
mov AL, 50  ; AL = 50 
sub AL, [b] ; AL = 50 - 3 = 47
sub AL, [c] ; AL = 47 - 2 = 45
mov DL, 2   ; DL = 2
mul DL      ; AX = AL * DL = 45 * 2 = 90
mov DX, AX  ; DX = AX = 90
mov AL, [a] ; AL = 6
mul AL      ; AX = AL * AL = 6 * 6 = 36
add AX, DX  ; AX = AX + DX = 36 + 90 = 126 
add AX, [d] ; AX = 126 + 10 = 136




        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
