;*************************************
;Suma binaria de 16 bits
;
;Autor: Alfredo Orozco de la paz
;
;Fecha: 5 de marzo del 2012
;*************************************

;Las direcciones de los operandos
;y de los resultados ocupan 2 bytes
;se resenrvan 2 bytes para cada variable.
loc1 equ 019h	
loc2 equ 01bh
loc3 equ 01dh

	XOR	A		;limpiamos el acarreo
	LD	A,(loc1)	;cargamos en a el byte bajo del primer
				;operador.
	LD	HL,loc2		;cargamos en HL la direccion del byte
				;bajo del segundo operador.
	ADD	A,(HL)		;sumamos los 2 bytes bajos sin tomar 
				;sin tomar en cuenta el acarreo.
	LD	(loc3),A	;guardamos el resultado en el byte bajo
				;de la variable.
	LD 	A,(loc1+1)	;cargamos en A el byte alto del primer
				;operador.
	INC	HL		;incrementamos el apuntador del segundo
				;operando, ahora apunta al byte alto.
	ADC	A,(HL)		;sumamos los 2 bytes datos tomando en
				;cuenta el acarreo.
	LD	(loc3+1),A	;guardamos el resultado en el byte
				;alto de la variable
	HALT
	