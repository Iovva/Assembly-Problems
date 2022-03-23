bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll 
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll 
import printf msvcrt.dll

; our data is declared here 
segment data use32 class=data

    nume_fisier db "input.txt", 0   	; numele fisierului care va fi deschis
    mod_acces db "r", 0            	 	; modul de deschidere a fisierului; r - pentru citire ; fisierul exista deja
    descriptor_fisier dd -1            	; variabila in care vom salva descriptorul fisierului
	len equ 100							; numarul maxim de elemente citite din fisier intr-o etapa
	sir_litere resb len+1				; sirul in care se va citi textul din fisier
	
	frecventa times ('Z'-'A'+1) dd 0	; un sir de frecventa care contine, initial, 26 ( numarul de litere in alfabetul englez) de 0-uri.
	
    litera_frecventa_maxima dd 0		; variabila in care memoram litera uppercase care apare de cele mai multe ori in fisier
	frecventa_maxima dd 0				; variabila in care memoram frecventa maxima a unei litere uppercase din fisier


	mesaj_afisare db "Litera uppercase de frecventa cea mai mare este:' %c ' si apare de ' %d ' ori in fisier", 10, 0 
	mesaj_afisare_caz_0 db "Nu exista nici o litera uppercase!", 10, 0
	
; our code starts here
segment code use32 class=code
    start:	
		; problema 8
		; Se da un fisier text.
		; Sa se citeasca continutul fisierului, sa se determine litera mare (uppercase) 
		; cu cea mai mare frecventa si sa se afiseze acea litera, impreuna cu frecventa acesteia.
		; Numele fisierului text este definit in segmentul de date.
		
        ; apelam fopen pentru a deschide fisierul
        ; functia va returna in EAX descriptorul fisierului sau 0 in caz de eroare
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        ; verificam daca functia fopen a deschis cu succes fisierul (daca EAX != 0)
		; sare la finalul programului, in caz contrar
        cmp eax, 0                  
        je final
        
        mov [descriptor_fisier], eax   ; salvam valoarea returnata de fopen in variabila descriptor_fisier
    
        bucla:
            ; citim o parte (100 caractere) din textul in fisierul deschis folosind functia fread
            push dword [descriptor_fisier] 		; variabila in care vom salva descriptorul fisierului
            push dword len						; = 100 - numarul de elemente citite intr-o etapa
            push dword 1						; dimensiunea unui element care va fi citit din fisier ( 1 byte )
            push dword sir_litere				; sirul in care se va citi textul din fisier
            call [fread]	
            add esp, 4*4						; eliberam parametrii de pe stiva
												; 4 = dimensiunea unui dword; 4 = nr de parametri
            
            ; avem in eax - numar de caractere citite
            cmp eax, 0          ; daca numarul de caractere citite este 0, am terminat de parcurs fisierul
            je cleanup
			
			mov ESI, sir_litere ; punem pe <DS:ESI> sirul in care se afla textul din fisier
			mov EDI, frecventa  ; punem pe <ES:EDI> sirul de frecventa
			
			mov ECX, EAX		; executam urmatorul bloc de operatii pentru fiecare caracter citit
			repeta:
			
				mov EAX, 0		
				lodsb			; punem pe AL valoarea unui octet din sirul de litere
								; avem in EAX - valoarea octetului
				cmp EAX, 'A'	; daca valoarea curenta nu este o litera uppercase, sare peste
				jl skip0
				cmp EAX, 'Z'
				jg skip0
				
				sub EAX, 'A'	; transforma literele din fisier astfel: A -> 0, B -> 1, ...
				
				inc dword[EDI+EAX*4]			; incrementeaza valoarea literei curenta din sirul de frecventa
				
				skip0:
			loop repeta
			
            ; reluam bucla pentru a citi alt bloc de caractere
            jmp bucla
       
		
      cleanup:
        ; apelam functia fclose pentru a inchide fisierul
        ; fclose(descriptor_fisier)
        push dword [descriptor_fisier]
        call [fclose]
        add esp, 4

	  mov ESI, frecventa					; punem pe <DS:ESI> sirul de frecventa
	  mov ECX, 0							
	  repeta1:								; executam blocul de operatii de 26 ( numarul de litere in alfabetul englez) de ori
		lodsd								; punem in EAX double-word-ul de la <DS:ESI>
		cmp EAX, [frecventa_maxima]			; daca elementul din EAX ( reprezentand frecventa unei litere ) este mai mare ca frecventa maxima, 
											; frecventa maxima devine valoarea din EAX, si variabila de litera ( reprezentand a cata litera din alfabetul
											; trebuie afisata ; A - 0, B - 1, ... ) 
		jle next
		mov [frecventa_maxima], EAX
		mov [litera_frecventa_maxima], ECX
		next:
		
		inc ECX								
	    cmp ECX, ('Z'-'A'+1)				; 'Z'-'A'+1 = 26 ( numarul de litere in alfabetul englez)
		jne repeta1
	  
	  mov EDX, [frecventa_maxima]			; daca frecventa maxima este 0, nu exista nici o litera uppercase in fisier si se sare la un caz special
	  cmp EDX, 0
	  JE caz_0
	  
	  mov EAX, [litera_frecventa_maxima]	; transforma elementul din EAX ( reprezentand a cata litera din alfabet trebuie afisata) in litera respectiva
											; 0 -> A, 1 -> B, ...
	  add EAX, 'A'
		  
	  
	  push dword [frecventa_maxima]			; punem frecventa maxima pe stiva
	  push dword EAX						; punem litera care apare de cele mai multe ori pe stiva
	  push dword mesaj_afisare 				; punem pe stiva se pune adresa string-ului de afisare
	  call [printf]     					; apelam functia printf pentru afisare
	  add esp, 4 * 3    					; eliberam parametrii de pe stiva; 4 = dimensiunea unui dword; 2 = nr de parametri
	  jmp final								; sare peste cazul in care frecventa maxima
	  
	  ; cazul in care frecventa maxima e 0
	  caz_0:								
	  push dword mesaj_afisare_caz_0 		; punem pe stiva se pune adresa mesajului de afisare a cazului in care frecventa maxima e 0
	  call [printf]      			 		; apelam functia printf pentru afisare
	  add esp, 4 * 2    					; eliberam parametrii de pe stiva; 4 = dimensiunea unui dword; 2 = nr de parametri
	  
      final:  
        ; exit(0)
        push    dword 0      
        call    [exit]       