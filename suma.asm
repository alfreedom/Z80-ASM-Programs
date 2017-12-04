VAR1	.equ	00010h
VAR2	EQU	00014h
VAR3	.EQU	00018h

	JP	Inicio
	org 	00050h	
	
Inicio:	LD	DE,VAR1
	LD	HL,VAR2
	CALL	Suma32
	JP	FIN
	
Suma8:	LD	B,1
	JP	Suma_	
Suma16:	LD	B,2
	JP	Suma_
Suma24:	LD	B,3
	JP	Suma_	
Suma32:	LD	B,4
	JP	Suma_
		
Suma_:	OR	A
	
CICLO:	LD	A,(DE)
	ADC	A,(HL)
	LD	(HL),A
	INC	DE
	INC	HL
	DJNZ	CICLO
	RET
	
FIN:	.END	