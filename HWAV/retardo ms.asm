
	.ORG 00000H
	
	LD D,0FFH
	CALL RETARDO
	HALT


RETARDO:
	LD	B,D
CICLO_R:
	CALL	DELAY_1MS
	DJNZ	CICLO_R
	RET

DELAY_1MS:
;Subrutina que demora aprox 1ms con una frecuencia de 8 MHZ
	EXX
	EX	AF,AF'
	LD	BC,0014Bh	;carga BC con 0067h, para demorar 1ms a 8 MHZ
CICLO_D:	
	DEC BC		;decrementa BC
	LD  A,C		;carga C en A para para compara si BC es 0
	OR  B		;compara A con B
	JP  NZ,CICLO_D	;si no es cero, saltamos a ciclo 2;
	EX	AF,AF'	;restaura los registros A y F
	EXX			;restaura todos los registros guardados en
				;los registros complementarios.
	RET			;regreso de la subrutina.