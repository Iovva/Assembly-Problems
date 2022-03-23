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

;20)  (a+a)-(c+b+d)

;a, b , c, d – byte

a DB 7
b DB 3
c DB 6
d DB 4


; our code starts here
segment code use32 class=code
    start:
    
mov AL, [a] ; AL = 7
add AL, [a] ; AL = 7 + 7 = 14
mov DL, [c] ; DL = 6
add DL, [b] ; DL = 6 + 3 = 9
add DL, [d] ; DL = 9 + 4 = 13
sub AL, DL  ; AL = 13 - 7 = 6


        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
