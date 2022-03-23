bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf	; adaugam printf si scanf ca functii externe
import exit msvcrt.dll    	
import printf msvcrt.dll  	; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll   	; similar pentru scanf

extern convert
global nr

; our data is declared here (the variables needed by our program)
segment data use32 class=data public
    ; ...
	
	mesaj_citire db "Problema 14:", 10
				 db 10, "Se citesc mai multe numere de la tastatura, in baza 2. Sa se afiseze aceste numere in baza 8.", 10,
				 db 10, 10, "Introduceti un numar n, urmat de n numere:", 10, 0					; mesajul este afisat la deschiderea programului
	
	mesaj_afisare db "Numarul %s in baza 8 este: %d", 10, 0										; mesajul este afisat, alaturi de numar in baza 8, dupa fiecare
																								; nr intrudous
		
	format_citire_n  db "%d", 0																	; n - numarul de numere - se citeste in baza 10
	n resd 1																					; se rezerva un doubleword pentru n 
	format_citire_nr db "%s", 0																	; nr - numerele in baza 2 - se citesc in string
																								; nu se verifica daca numerele sunt in baza 2!!!!	
	nr times 33 db 0																			; numerele sunt stringuri de maxim 32 de biti ( 4 octeti )
																								; ultimul octet este ' 0 ' ( nu caracterul 0 , de valoare 48 ASCII )
	nr_baza_8 resd 1																			; numarul in baza 8, il tranferam in eax
	
; our code starts here
segment code use32 class=code public
    start:
	
	; Problema 14:
	; Se citesc mai multe numere de la tastatura, in baza 2. Sa se afiseze aceste numere in baza 8.

		push dword mesaj_citire 			; punem pe stiva adresa string-ului ( cerinta )
        call [printf]      		 			; apelam functia printf pentru afisarea cerintei
        add esp, 4 * 1     		 	
		   
        push dword n	   					; punem pe stiva adresa numarului citit
		push dword format_citire_n			; punem pe stiva formatul de citire
        call [scanf]       					; apelam functia scanf pentru citire
        add esp, 4 * 2     
		
		mov ECX, [n]						; punem in ecx valoarea lui n, pentru a citi si converti n numere
		cmp ECX, 0
		JG repeta							; daca ecx este mai mare decat 0, sare la secventa repetitiva
		jmp final							; daca numarul de numere citite este 0, sare la finalul algoritmului
		
		repeta:
								
			pushad							; salvam pe stiva registrii
			push dword nr	   				; punem pe stiva adresa numarului citit
			push dword format_citire_nr		; punem pe stiva formatul de citire
			call [scanf]       				; apelam functia scanf pentru citire
			add esp, 4 * 2								
			popad							; restituim registrii
			
			pushad
				;----
					;functie
					call convert
				;----
			mov [nr_baza_8], EAX			; punem in variabila numarul din baza 8 
			popad
			cld								; setam direction flag-ul la 0 pentru apelul functiei prinf
			pushad							; salvam pe stiva registrii
			push dword [nr_baza_8]			; in nr_baza_8 avem avem salvat valoarea numarului curent in baza 8
			push dword  nr
			push dword mesaj_afisare 		; punrem pe stiva se pune adresa string-ului
			call [printf]      		 		; apelam functia printf pentru afisare
			add esp, 4 * 3 					
			popad							; restituim registrii
				
		dec ECX								; decrementam ECX pentru fiecare numar citit
		JECXZ final							; daca ECX e 0, sare la final
		JMP repeta							; daca nu, reia algoritmul de citire si convertire
		

		final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
