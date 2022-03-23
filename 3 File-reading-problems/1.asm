; Ne propunem ca programul de mai jos sa citeasca de la tastatura un numar si sa afiseze pe ecran valoarea numarului citit impreuna cu un mesaj.
bits 32
global start        

; declararea functiilor externe folosite de program
extern exit, printf, scanf  ; adaugam printf si scanf ca functii externe           
import exit msvcrt.dll     
import printf msvcrt.dll     ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll      ; similar pentru scanf
                          
segment  data use32 class=data

	; impartim mesajul de deschidere al programului in 5 mesaje mai scurte, pentru a le putea 
	; utiliza mai usor
	mesaj_citire1 db 10, "Programul primeste de la tastatura doua numere a si b de tip word.", 10, 0
	mesaj_citire2 db "si afiseze in baza 16 numarul c de tip dword pentru care:", 10, 0
	mesaj_citire3 db " - partea low este suma celor doua numere", 10, 0
	mesaj_citire4 db " - partea high este diferenta celor doua numere ", 10, 0 
	mesaj_citire5 db 10, "Introduceti doua numre (in baza 10):", 10, 10, 0
	
	format_citire  db "%d", "%d", 0  ; %d <=> un numar decimal (baza 10
	
	a resd 1	   ; stocam in aceasta variabila prima valoare citita de la tastatura
	b resd 1	   ; stocam in aceasta variabila a doua valoare citita de la tastatura
	
	; mesajul final: 
	mesaj_afisare  db 10, "Numarul format este n= %xh", 10, 0  
    
segment  code use32 class=code
    start:
	
		; problema 21:
		; Sa se citeasca de la tastatura doua numere a si b de tip word. 
		; Sa se afiseze in baza 16 numarul c de tip dword pentru care 
		; partea low este suma celor doua numere, iar partea high este
		; diferenta celor doua numere.
		
		
        ; vom apela  functia printf(message) => se va afisa "Programul primeste de la tastatura doua numere 
		;											         a si b de tip word.", urmat de newline.
        ; punem parametrul ( sirul de caractere, terminat cu 0) pe stiva
		push dword mesaj_citire1 	; punrem pe stiva se pune adresa string-ului ( mesaj_citire1 )
        call [printf]      		 	; apelam functia printf pentru afisare
        add esp, 4*1     		 	; eliberam parametrii de pe stiva ; 4 = dimensiunea unui dword; 1 = nr de dword-uri
		
		; procedam la fel, pentru mesaj_citire2, ... , mesaj_citire5
		; ( segmentam mesajul de citire in 5 pentru a le putea utiliza mai usor )
		push dword mesaj_citire2 
        call [printf]      
        add esp, 4*1       
		push dword mesaj_citire3  
        call [printf]      
        add esp, 4*1       
		push dword mesaj_citire4 
        call [printf]      
        add esp, 4*1     
		push dword mesaj_citire5 
        call [printf]      
        add esp, 4*1       
		
		
        ; vom apela scanf(format, a, b) => se vor citi doua numere, in variabilele a si b
        ; punem parametrii ( adresele numerelor si formatul de citire ) pe stiva de la dreapta la stanga
        push dword b       ; punem pe stiva adresa celui de-al doilea numar citit
        push dword a	   ; punem pe stiva adresa primului numar citit
		push dword format_citire	; punem pe stiva formatul de citire
        call [scanf]       ; apelam functia scanf pentru citire
        add esp, 4 * 3     ; eliberam parametrii de pe stiva
                           ; 4 = dimensiunea unui dword; 3 = nr de parametri
		
		
		mov EAX, 0		   ; EAX = 00000000h
		mov AX, word[a]	   ; punem in AX valoarea primului numar
		mov BX, word[b]	   ; punem in BX valoarea celui de-al doilea numar
		cmp AX, BX 		   
		JGE skip		   ; daca numarul din var. a este mai mic ca cel din var. b,
						   ; are loc interschimbarea valorilor din variabile, cat
						   ; si din registrii:
		mov [b], AX 
		mov [a], BX		   ; a <-> b
		mov AX, word[a]
		mov BX, word[b]	   ; AX <-> BX
		skip:
		
		
		sub AX, BX		   ; realizeaza scaderea celor doua numere, rezultatul fiind
						   ; trecut in AX
		mov CL, 16		   ; punem in registrul CL valoarea 16, pentru o urmatoare
						   ; operatii pe biti
		shl EAX, CL		   ; shiftam bitii din EAX la stanga cu un word, astfel
						   ; incat valoarea precedenta din AX este acum in
						   ; word-ul high din EAX
		
		mov AX, word[a]	   ; punem in AX primul numar, intrucat AX s-a modificat
						   ; in urma operatiilor precedente
		add AX, BX		   ; realizeaza adunarea celor doua numere, rezultatul fiind

		
        ; vom apela printf => se va afisa:  "Numarul format este n=", urmat de numar in baza 16
        ; punem parametrii pe stiva de la dreapta la stanga
        push dword EAX	   ; punem numarul din cerinta pe stiva
        push dword mesaj_afisare ; punem pe stiva se pune adresa string-ului
        call [printf]      ; apelam functia printf pentru afisare
        add esp, 4 * 2     ; eliberam parametrii de pe stiva; 4 = dimensiunea unui dword; 2 = nr de parametri
		  
		
        push  dword 0     ; punem pe stiva parametrul pentru exit
        call  [exit]       ; apelam exit pentru a incheia programul