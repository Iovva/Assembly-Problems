bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data

    lungime_cuvant resb 1						; lungimea cuvantului curent din sirul sursa
    
	pozitie_sir_final resb 1					; pozitia unde trebuie adaugat noul element in sirul final
	
    sir db 	'capac maine casa cojoc apa '		; sirul sursa
    len equ $-sir					
    
    sir_invers times len+2 db 0					; sirul invers
												; se formeaza prin scrierea inversa a fiecarui cuvant din sirul sursa
												; 	ex   :  sirul initial este : 'capac maine casa cojoc apa '
												; 			sirul invers va fi : 'capac eniam asac cojoc apa '
												; il folosim pentru a compara fiecare cuvant cu inversul sau
												; lungimea este len + 2 pentru a nu interfera cu sirul final
												; 			( daca nu lasam spatii dupa cuvinte, ar incaprea doar pe len,
												;  			  dar sirul invers ar arata asa : 'capacmaine'
												;									 nu asa : 'capac maine ' )
												
	sir_final times len db 0					; sirul in care trecem toate palindroamele din sirul sursa

	
; our code starts here
segment code use32 class=code
    start:

    mov ESI, sir								; ESI - adresa primului element din sirul initial
    mov EDI, sir_invers							; EDI - adresa ultimului element din sirul invers
    mov ECX, len          						; punem in ECX lungimea sirului pentru a termina algoritmul odata cu terminarea caracterelor din sirul initial
	mov BL, 0									; BL - pozitia unde trebuie adaugat noul element in sirul final

	
        Repeta:
        
		; aflam lungimea cuvantului :
            cld									; parcurgem sirul de la stanga la dreapta ( DF = 0 )			
            mov DL, 0 						    ; DL - lungimea cuvantului
                Lungime_Cuvant:
                    inc DL 						; incrementam lungimea cuvantului
                    LODSB						; incarcam in AL octetul de la adresa <DS:ESI> ( incarcam caracterul din sirul initial )
                    cmp AL,' '					; comparam octetul din AL cu caracterul ' '
                    jnz Lungime_Cuvant			; daca in urma comparatiei, caracterul din AL nu este ' ', se reia procesul de incrementare a lungimii cuvantului
					
            dec DL								; decrementam DL intrucat lungimea cuvantului s-a marit si pentru caracterul ' '
            mov [lungime_cuvant], DL 			; memoram in lungime_cuvant valoarea lui DL pentru a putea lucra cu registrul
			
 			dec ESI
			dec ESI								; decrementam ESI de doua ori pentru a ajunge la ultima litera din cuvantul curent al sirului sursa
												; ( in urma aflarii lungimii cuvantului, ESI memoreaza adresa primei litere din cuvantul urmator din sirul initial )
												
												; 	avem: 	- ESI - adresa ultimului caracter din cuvantul initial ( din sirul sursa )
												; 			- EDI - adresa primului caracter din cuvantul destinatie ( din sirul destinatie )	       
							


							
		; construim in sirul destinatie cuvantul invers al cuvantului din sirul sursa :
				Creeare_Cuvant_Invers:
                    std 						; parcurgem sirul initial de la dreapta la stanga ( DF = 1 )
                    LODSB						; incarcam in AL octetul de la adresa <DS:ESI> ( incarcam caracterul din sirul initial )
                    cld							; parcurgem sirul invers de la stanga la dreapta ( DF = 0 )	
                    STOSB						; incarcam la adresa <DS:EDI> octetul din AL   ( incarcam caracterul in sirul destinatie )
						
												; in urma opratiilor de mai sus :
												; caracterul de pe pozitia n-i din cuvantul initial este pus pe pozitia i in cuvantul destinatie
												; unde n este lungimea cuvantului si i este pozitia elementului ( 1 <= i <= n )
												; ex :			  sursa:			  destinatie:
												;			p0) cuvant1 : casa   ;   cuvant2 : 
												;			p1) cuvant1 : casA   ;   cuvant2 : A		
												;			p2) cuvant1 : caSa   ;   cuvant2 : aS	
												;			p3) cuvant1 : cAsa   ;   cuvant2 : asA	
												;			p4) cuvant1 : Casa   ;   cuvant2 : asaC	
              
                    dec DL             	   		
                    cmp DL, 0					; executa operatiile de mai sus de DL ori  ( DL - lungimea cuvantului )
                    jg Creeare_Cuvant_Invers 	
					
            inc ESI								; incrementam ESI pentru a ajunge la prima litera din cuvantul sursa
												; ( in urma construirii cuvantului, ESI memoreaza adresa precedenta primului caracter din cuvantul sursa )
												
												; 	avem: 	- ESI - adresa primului caracter din cuvantul initial ( din sirul sursa )
												; 			- EDI - adresa ultimului caracter din cuvantul destinatie ( din sirul destinatie )
		
		
		; decrementam EDI de lungime_cuvant ori pentru a ajunge la adresa primei litere din cuvantul invers :
			mov DL, 0
				decrementare_litera_copie:
					dec EDI						; decrementam EDI
				
					inc DL
					cmp DL, [lungime_cuvant]	; executa decrementarea lui EDI de lungime_cuvant ori
					jne decrementare_litera_copie
												
												; 	avem: 	- ESI - adresa primului caracter din cuvantul initial ( din primul sir )
												; 			- EDI - adresa primului caracter din cuvantul destinatie ( din al doilea sir )
		
		
		
		; comparam cuvantul din sirul sursa cu inversul lui din sirul destinatie pentru a verifica daca sunt identice :
			mov DL,0
			cld									; parcurgem cele doua siruri de la stanga la dreapta ( DF = 0 )
                Verificare_Palindrom:
                    CMPSB						; compara octetul de la adresa <DS:ESI> cu cel de la adresa <ES:EDI>
                    jne incrementare_EDI_ESI	; daca cei doi octeti nu sunt egali => cuvantul nu este identic cu oglinditul sau => nu este palindrom
                
                    inc DL			
                    cmp DL, [lungime_cuvant]	; executa operatia de comparare de lungime_cuvant ori
                    jne Verificare_Palindrom
            
			

			
		; 1) cazul in care cuvantul este palindrom :
		; il adaugam in sir_final
        
												; 	avem: 	- ESI - adresa primului caracter din urmatorul cuvant al sirului initial
												; 			- EDI - adresa primului caracter din urmatorul cuvant al sirului destinatie 
					
		; decrementam ESI de lungime_cuvant ori pentru a ajunge la adresa primei litere
            mov DL, 0
				decrementare_litera_sursa:
					dec ESI
				
					inc DL
					cmp DL, [lungime_cuvant]	; executa decrementarea lui ESI de lungime_cuvant ori
					jne decrementare_litera_sursa
				
												; 	avem: 	- ESI - adresa primului caracter din cuvantul initial al sirului sursa
												; 			- EDI - adresa primului caracter din urmatorul cuvant al sirului destinatie 
		
		
		
		
			push EDI 							; punem adresa sirului invers pe stiva
			mov EDI, sir_final 					; punem adresa sirului final in EDI, pentru a putea realiza copierea 
												;        sirului sursa in sirul final, fosind instructiuni specifice 
												;  		 lucrului cu siruri
		
			mov [pozitie_sir_final], BL			; memoram in variabila pozitie_sir_final valoarea lui BL pentru a putea 
												;										decrementa valoarea registrului
		
												; 	avem:   - EDI - adresa primului caracter din sirul final 	
		
		

		; incrementam adresa sirului final pana depasim pozitia primului caracter ' ' de dupa ultimul cuvant 
			cmp BL, 0							; comparam valoarea din BL cu 0
			jz skip								; daca : - valoarea este diferita de 0 se incrementeaza pozitia de BL ori
												; 		 - valoarea este 0, atunci adaugam primul cuvant si nu este nevoie de incrementare
				incrementare_sir_final:
						inc EDI					; incrementam EDI 
					
						dec BL
						cmp BL, 0				; efectuam incrementarea de BL ori
						jne incrementare_sir_final 
					
			skip:
			
												; 	avem:   - EDI - adresa de dupa primul caracter ' ' de dupa ultimul cuvant
												;				    ( adica pozitia unde trebuie adaugat cuvantul curent,
												;				      pastrand caracterul ' ' fata de cel precedent )
			
			
		; adaugam cuvantul palindrom la sirul final
			cld									; parcurgem cele doua siruri de la stanga la dreapta ( DF = 0 )
				adaugare_palindrom: 
						LODSB					; incarcam in AL octetul de la adresa <DS:ESI> ( incarcam in AL caracterul din sirul initial )
						STOSB					; incarcam la adresa <DS:EDI> octetul din AL   ( incarcam caracterul din AL in sirul final )
					
						cmp AL,' '				; comparam octetul din AL cu caracterul ' '
						jnz adaugare_palindrom	; daca in urma comparatiei, caracterul din AL nu este ' ', se reia procesull de incrementare a lungimii cuvantului


							
			mov BL, [pozitie_sir_final] 		; punem in BL valoarea din pozitie_sir_final
												;  		astfel : BL reprezinta pozitia primul caracter din ultimul cuvant ( pe care tocmai l-am adaugat )
			add BL, [lungime_cuvant]			; adaugam lungimea cuvantului curent valorii lui BL
												; 		astfel : BL reprezinta pozitia caracterului ' ' de dupa ultimul cuvant
			inc BL								; incrementam valoarea lui BL
												; 		astfel : BL reprezinta prima pozitie de dupa primul caracter ' ', ce se afla dupa ultimul cuvant
												;				 ( adica pozitia unde trebuie adaugat urmatorul cuvant,
												;				   pastrand caracterul ' ' fata de cel precedent )
		
		
			pop EDI 							; punem, din stiva, adresa sirului invers in EDI, intrucat am terminat modificarea sirului final
			JMP decrementare					; sarim cazul in care cuvantul nu este palindrom
				
				
		
		
		
		; 2) cazul in care cuvantul nu este palindrom :    
		; incrementarea lui EDI si ESi s-a terminat prematur
		
												; 	avem: 	- ESI - adresa primului caracter din sirul initial care nu coincide 
												;					cu caracterul din sirul destinatie de pe aceeasi pozitie				
												;			     	( adresa primului caracter care strica regula palindromului din sirul initial)
												; 			- EDI - adresa primului caracter din sirul destinatie care nu coincide 
												;					cu caracterul din sirul destinatie de pe aceeasi pozitie	
												;					( adresa primului caracter care strica regula palindromului din sirul destinatie)
												
		; incrementam ESI si EDI de ( lungime_cuvant - DL ) ori:
		; ( terminam operatia de incrementare inceputa in Verificare_Palindrom )
		; ( DL - (pozitia elementului care a stricat regula palindromului) - 1 )
												; ex :  - cuvantul are 5 litere => lungime_cuvant = 5 
												;		- primul caracter care strica regula palindromului este al doilea => DL = 1
												;									( DL nu a fost incrementat si pentru al doilea caracter,
												;									  deoarece DL este incrementat doar daca trece de primul jump )
												;
												;       Atunci, pentru ca : - ESI sa ajunga la prima litera din urmatorul cuvant al sirului sursa ( depasind ' ' )
												;							- EDI sa ajunga la prima litera din urmatorul cuvant al sirului destinatie ( depasind ' ' )
												;    		  => ESI si EDI trebuie incrementate de ( 5-2 ) + 1 ori <=> 5 - 1 ori <=> (lungime_cuvant - DL) ori
												;						  				  			 +5 -> lungimea cuvantului
												;													 -2 -> pozitia elementului care strica regula
												;													 +1 -> pentru a trece peste caracterul ' '
				incrementare_EDI_ESI:
					inc ESI						; incrementam ESI pentru a ajunge la prima litera din urmatorul cuvant din sirul sursa
					inc EDI						; incrementam EDI de pentru a ajunge la prima litera din urmatorul cuvant din sirul destiatie
				
					inc DL						
					cmp DL, [lungime_cuvant]	; executa operatia de incrementare de ( lungime_cuvant - DL ) ori
					jne incrementare_EDI_ESI
												

			
												
										
				decrementare:
				; indiferent de caz, au loc urmatoarele operatii:
				
												
												; 	avem: 	- ESI - adresa primului caracter din urmatorul cuvant al sirului initial
												; 			- EDI - adresa primului caracter din urmatorul cuvant al sirului destinatie 
												;			- sir_final - modificat sau nu
				
				
				
        ; decrementam ECX de DL (lungimea cuvantului) ori    
			mov DL, [lungime_cuvant]			
				decrementare_operatie:
					dec ECX 					; decrementam ECX pentru fiecare caracter din cuvant
				
					dec DL							
					cmp DL, 0					; executa operatia de decrementare de lungime_cuvant ori
					jne decrementare_operatie
			dec ECX								; decrementam ECX pentru caracterul ' '
				
        
			inc EDI 							; incrementam EDI pentru a pastra caracterul ' ' intre cuvinte
												; ( in urma operatiilor de mai sus, EDI contine adresa primului caracter ' ' de dupa ultimul cuvant,
												;   			    	   NU adresa primului caracter de dupa primul ' ', aflat dupa ultimul cuvant )
												; linia de cod este optionala, dar pastreaza lizibilitatea in sirul invers
												
			cmp ECX, 0  						; daca ECX = 0, se termina analizarea sirului				
			jg Repeta
		
		
		
	mov EDI, sir_final							; punem in EDI adresa primului element din sirul palindrom
    
	
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
