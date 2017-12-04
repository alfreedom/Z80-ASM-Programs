;Rutinas de operaciones basicas con numeros de 16,24 y 32 bits.
VAR1	.EQU	090h
VAR2	.equ	094h
	
Inicio:	LD	HL,VAR1	;Cargamos la direcion del primer numero en HL
	;LD	DE,VAR2	;Cargamos la direcion del segundo numero en DE
	CALL	CPL16 ;Hacemos la resta (VAR1)=(DE)-(HL)
	HALT
	JP	FIN


;/////////////////////////////////////////////////////////////
;Rutinas para complementar numeros de 16,24 y 32 bits
;La direccion del dato a complementar se debe guardar en HL
;
;
;
;Ejemplo
;	LD 	HL,VAR1	;Cargamos el apuntador a la variable en HL
;	CALL	CPL16	;Complementamos el contenido de la variable
;			;(VAR1)= !(VAR1)
	
CPL16:	LD	B,2
	JP	CPL_
CPL24:	LD	B,3
	JP	CPL_
CPL32:	LD	B,4
	JP	CPL_
CPL_	LD	A,(HL)
	CPL		
	LD	(HL),A
	INC	HL
	DJNZ	CPL_
	RET
;/////////////////////////////////////////////////////////////

;/////////////////////////////////////////////////////////////	
;Rutinas para incrementar numeros de 16,24 y 32 bits
;La direccion del dato a incrementar se debe guardar en HL
;
;
;
;Ejemplo
;	LD 	HL,VAR1	;Cargamos el apuntador a la variable en HL
;	CALL	INC16	;Incrementamos el contenido de la variable
;			; (VAR1)= (VAR1)+1
			
INC16:	LD	B,2
	JP	INC_
INC24:	LD	B,3
	JP	INC_
INC32:	LD	B,4
	JP	INC_
INC_	LD	A,0FFh
	INC	A	
CINC_:	LD	A,(HL)
	ADC	A,0
	LD	(HL),A
	INC	HL
	DJNZ	CINC_
	RET	
;/////////////////////////////////////////////////////////////

;/////////////////////////////////////////////////////////////
;Rutinas para sumar numeros de 16,24 y 32 bits
;Las direcciones de los datos a sumar se deben guardar 
;en HL y DE, y el resultado se guarda en al direccion de la 
;variable asignada a HL
;
;Ejemplo
;	LD	DE,VAR1	;Cargamos el apuntador a la variable 1 en DE
;	LD	HL,VAR2	;Cargamos el apuntador a la variable 2 en HL
;	CALL	SUMA32  ; (VAR2)=(HL)+(DE)

SUMA16:	LD	B,2
	JP	SUMA_
SUMA24:	LD	B,3
	JP	SUMA_	
SUMA32:	LD	B,4
	JP	SUMA_		
SUMA_:	OR	A	
CSUMA_:	LD	A,(DE)
	ADC	A,(HL)
	LD	(HL),A
	INC	DE
	INC	HL
	DJNZ	CSUMA_
	RET	
;/////////////////////////////////////////////////////////////

;/////////////////////////////////////////////////////////////
;Rutinas para restar numeros de 16,24 y 32 bits
;Las direcciones de los datos a restar se deben guardar 
;en HL y DE, y el resultado se guarda en al direccion de la 
;variable asignada a HL. Se realiza [(HL)=(DE)-(HL)]
;
;Ejemplo
;	LD	DE,VAR1	;Cargamos el apuntador a la variable 1 en DE
;	LD	HL,VAR2	;Cargamos el apuntador a la variable 1 en DE
;	CALL	RESTA32 ;Hacemos la resta (VAR2)=(DE)-(HL)

RESTA16:	LD	B,2
		JP	RESTA_
RESTA24:	LD	B,3
		JP	RESTA_	
RESTA32:	LD	B,4
		JP	RESTA_		
RESTA_:		OR	A	
CRES_:		LD	A,(DE)
		SBC	A,(HL)
		LD	(HL),A
		INC	DE
		INC	HL
		DJNZ	CRES_
		RET	
;/////////////////////////////////////////////////////////////

FIN:	HALT
