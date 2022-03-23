#include <stdio.h>
#include <stdlib.h>

int convert(char* str);

int main()
{
	// Problema 14:
	// Se citesc mai multe numere de la tastatura, in baza 2. Sa se afiseze aceste numere in baza 8
    int n;
    printf("n = ");								
    scanf("%d", &n);								// citim numarul n
    char* numar_binar = (char*)malloc(33);			// aloca dinamic 33 de bytes pentru sirul care reprezinta numarul binar
    for(int i = 0; i < n; ++i)																								// executam conversia de n ori
    {
        printf("Introduceti de la tastatura un numar in baza 2 pe maxim 32 de biti: ");									
        scanf("%s", numar_binar);																							// citeste stringul care reprezinta numarul binar
        printf("Reprezentarea in octal (baza 8) a numarului binar %s este: %d\n", numar_binar, convert(numar_binar));		// realizeaza conversia si afiseaza numarul
    }
    return 0;
}