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

; b-(b+c)+a  ; a, b, c, d – word

a DW 30
b DW 20
c DW 10


; our code starts here
segment code use32 class=code
    start:
    
mov AX, [b] ; AX = 20
mov DX, [b] ; DX = 20
add DX, [c] ; DX = 20 + 10 = 30
sub AX, DX  ; AX = 20 - 30 = -10
add AX, [a] ; AX = -10 + 30 = 40



        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
