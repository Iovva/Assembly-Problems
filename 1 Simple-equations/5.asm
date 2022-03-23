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

;20) [(a+b+c)*2]*3/g
; a, b, c, d -byte, e, f, g, h – word

a DB 1
b DB 2
c DB 3
g DW 5


; our code starts here
segment code use32 class=code
    start:
    
mov AL, [a]  ; AL = 1
add AL, [b]  ; AL = 1 + 2 = 3
add AL, [c]  ; AL = 3 + 3 = 6
mov DL, 2    ; DL = 2 
mul DL       ; AX = AL * DL = 6 * 2 = 12
mov DX, 3    ; DX = 3 
mul DX       ; DX:AX = AX * DX -> DX:AX = 12 * 3 = 36
mov BX, [g]  ; BX = 5
div BX       ; AX = DX:AX / BX -> AX = 36 / 5 = 7
             ; DX = DX:AX % BX -> DX = 36 % 5 = 1





        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
