Suma8:	LD	B,1
	JP	Suma_	
Suma16:	LD	B,2
	JP	Suma_
Suma32:	LD	B,3
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