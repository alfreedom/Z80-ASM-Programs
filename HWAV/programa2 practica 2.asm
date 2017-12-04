
	.ORG 00000H
	LD	 SP,0FFFFh	;carga el SP con la direccion más alta de la RAM
	LD	 D,00fH		;carga el numero de ms en D
	CALL RETARDO_MS ;llama a la subrutina RETARDO_MS
	HALT	        ;modo halt


RETARDO_MS:
	LD	B,D		;carga el numero de milisegundos en B
CICLO_R:
	CALL DELAY_1MS	;llama a la subrutina DELAY_1MS
	DJNZ CICLO_R	;decrementa B y si no es cero, salta a la etiqueta CICLO_R
	RET


;Subrutina que demora aprox 1ms con una frecuencia de 8 MHZ
DELAY_1MS:
	EXX				;guarda los registros en los pares complementarios
	EX	AF,AF'		;guarda los registros A y F
	LD	BC,0014Bh	;carga BC con 0067h, para demorar 1ms a 8 MHZ
CICLO_D:	
	DEC BC		 ;decrementa BC
	LD  A,C		 ;carga C en A para para compara si BC es 0
	OR  B		 ;compara A con B
	JP  NZ,CICLO_D	;si no es cero, saltaa CICLO_D;
	EX	AF,AF'	 ;restaura los registros A y F
	EXX			 ;restaura todos los registros guardados en
				 ;los registros complementarios.
	RET