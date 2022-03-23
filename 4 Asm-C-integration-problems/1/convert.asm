bits 32 
global convert 
extern nr

segment data use32 class=data public

nr_baza_8_cifre resd 1 						; numarul de cifre din numarul in baza 8

segment code use32 class=code public 

convert: 

		mov ESI, nr							; punem in ESI adresa string-ului ( care reprezinta numarul in baza 2 ) 				
		mov ECX, 0							; punem in ECX valoarea 0 ( ulterior, in ECX vom avea numarul de cifre din numarul in baza 2)
		cld									; parcurgem sirul de la stanga la dreapta
		
		repeta1:						
			lodsb							; punem in AL un byte din numarul reprezentat de string, intrucat o cifra a numarului se afla pe un byte
			cmp AL, 0						
			je next							; daca ajungem la finalul cuvantului, incheiem procesul de cautare
			inc ECX							; incrementam ECX pentru fiecare cifra din string
		jmp repeta1							
		
		next:
		sub ESI, 2							; punem in ESI adresa ultimei cifre din numarul in baza 2
		std									; parcurgem sirul de la dreapta la stanga 
		mov dword[nr_baza_8_cifre], 0		; punem in variabila numarul de cifre din baza 8 ( la inceput, 0 )

		repeta2:
		
			mov EDX, 0						; in EDX formam cifrele in baza 8
											; ( conversie rapida din baza 2 in baza 8 :
											;	luam ultimele 3 cifre din numarul in baza 2, si transformam astfel : a2 * 4 + a1 * 2 + a0 * 1,
											;   																	 unde: a2 - ante-penultima cifra
											;																			   a1 - penultima cifra
											;																			   a0 - ultima cifra
											;  		daca sunt mai putin de 3 cifre, se formeaza doar cu cifrele existente
			
			mov EBX, 1						; EBX = 1
			lodsb							; punem ultima cifra din numarul in baza 2 in al
			sub AL, '0'						; scadem din cifra codul ascii a lui '0';   '0' - > 0
											;											'1' - > 1
			cmp AL, 0						
			je next1						; daca e 0, se trece la urmatorul pas
			add EDX, EBX					; daca e diferita de 0, se aduna 1 la cifra in baza 8, care se afla in formare
			
			next1:	
			dec ECX							; decrementam numarul de cifre ramase din numarul in baza 2
			JECXZ next4						; daca ECX e 0, nu mai avem cifre in baza 2, sarim la urmatorul pas
			
			add EBX, EBX					; EBX = 2
			lodsb							; echivalent pentru primul adaos
			sub AL, '0'
			cmp AL, 0
			je next2
			add EDX, EBX
			
			next2:
			dec ECX
			JECXZ next4
			
			add EBX, EBX					; EBX = 2
			lodsb							; echivalent pentru primul adaos
			sub AL, '0'
			cmp AL, 0
			je next3
			add EDX, EBX
			
			next3:
			dec ECX
			JECXZ next4
			
			push EDX						; punem cifra ( in baza 8 ) foramta in EDX pe stiva
											; ( cifrele numarului se formeaza in ordine inversa, le punem pe stiva pentru a le inversa )
			inc dword[nr_baza_8_cifre]		; incrementam numarul de cifre ale numarului in baza 8 
			
		jmp repeta2			
		
		next4:	
		cld 								; restituim df-ul la valoarea 0
		push EDX							; punem cifra ( in baza 8 ) foramta din ultimele cifre in EDX pe stiva
		inc dword[nr_baza_8_cifre]			; incrementam numarul de cifre ale numarului in baza 8 
		mov ECX, [nr_baza_8_cifre]			; punem in ECX numarul de cifre ale numarului in baza 8
		
		mov EAX, 0							; in eax formam cuvantul
		repeta3:
			pop EDX							; in EDX punem ultima cifra
			add EAX, EDX					; adaugam la numarul din EAX ( in baza 8 ) ultima cifra
			mov EDX, 10						
			mul EDX							; inmultim numarul in baza 8 cu 10 ( pentru a muta cifrele in stanga cu o unitate)
											; practic numarul este returnat in baza 10, dar are forma unui numar in baza 8
		LOOP repeta3							
					
		mov EDX, 0							
		mov BX, 10							; impartim numarul cu 10, deoarece este inmultit cu 10 o data in plus 
		div BX

ret 