 

	LD   SP,67FFh
	LD   D,0Ah
	LD   E,05H
	CALL DIVIDE
	HALT
;Esta subrutina divide dos números enteros de 8-bits 
; Entrada: Dividendo en D y divisor en E 
; Salida: Cociente en L y residuo en C 
; Registros modificados: B,C, y L 
; Llama a subrutinas DIV8 y RESULT 
	
DIVIDE:	LD   B,08h	; Contador de rotaciones 
	LD   L,0	; L tendrá el cociente 
	LD   C,L	; C tendrá el residuo parcial 
	
NEXTBIT: 
	CALL    DIV8	; Divide dos números de 8 bits 
	CALL	RESULT	; Almacena los resultados 
	DEC	B
	JP	NZ,NEXTBIT	; Decrementa el contador de rotaciones 
	RET		; FIN
	
DIV8:	LD	A,D	; Guarda el dividendo
	RLCA		; Envía el bit al carry 
	LD	D,A	; Guarda el resto del dividendo 
	RLA		; Combine el bit CY con el residuo 
	CP	E	;  Checa si el divisor > dividendo parcial 
	RET	C	;  Si CY=1, divisor > dividendo parcial 
	DEC	B	;  Resta el divisor del dividendo parcial 
	RET		;  Termina 

RESULT:	LD	C,A	; Guarda residuo parcial 
	CCF		; Pone CY=1 o 0 según sea el cociente 
	LD	A,L	; Obtiene el cociente previo 
	RLA		; Suma el cociente de la bandera CY 
	LD	L,A	; Guarda el cociente parcial 
	RET 