# Simple arithmetic programs

1) 13/3
2) (a+a)-(c+b+d)  ; a, b, c, d – byte
3) b-(b+c)+a  ; a, b, c, d – word
4) (50-b-c)*2+a*a+d  ; a, b, c- byte, 
		       d – word
5) [(a+b+c)*2]*3/g ; a, b, c, d -byte,
                     e, f, g, h – word

6) (a+b+c)-(d+d)+(b+c) ; a - byte, b - word,
			  c - double word, 
			  d - qword,	
			  unsigned
7) (a+b-c)+(a+b+d)-(a+b) ; a - byte,
			   b - word,
			   c - double word,
			   d - qword, 
			   signed
8) (a*a+b+x)/(b+b)+c*c ; a-word, 
			 b-byte, 
			 c-doubleword,
			 x-qword,
			 unsigned
9) (a*a+b+x)/(b+b)+c*c ; a-word,
			 b-byte,
			 c-doubleword,
			 x-qword,
			 signed 
 

To change the parameters, change them in the data segment.
The result should appear in the debugging window, before the exit call.

