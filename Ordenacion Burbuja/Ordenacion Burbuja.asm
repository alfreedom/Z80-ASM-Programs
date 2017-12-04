;########################################################
;# Programa que ordena una lista ASCENDENTEMENTE de 	#
;# numeros  binarios de 8 bits con signo, la longitud 	#
;# de la lista esta en la localidad 1B00h, y la misma 	#
;# lista comienza en la localidad 1B01h.		#
;# los numeros estan representados como complemento A2.	#
;########################################################

	DIRECCION .equ 1B01h
	LONGITUD  .equ 1B00h
	
		LD    SP,67FFh		;se inicializa el Stack Pointer
		
;====================================================================================================================
;========================ALGORITMO DE ORDENACION POR BURBUJA=========================================================
;====================================================================================================================
BURBUJA:	LD    IX,DIRECCION	;Se carga la direccion del primer elemento de la tabla en IX
		LD    IY,DIRECCION+1	;Se carga la direccion del segundo elemento de la tabla en IX
		LD    HL,LONGITUD	;se carga la direccion del tamaño de la tabla en HL
		LD    B,(HL)		;se carba B con el tamaño de la tabla
		DEC   B			;decrementamos B, para recorrer N-1 elementos
		RES   0,C		;limpiamos la bandera que indica si hubo cambio
CICLO:		CALL  CP_S8		;llamamos a la subrutina que compara 2 numeros de 8 bits con signo
		JR    C,CAMBIO		;si hay acarreo ( (IY) < (IX) ), intercambiamos los valores
CONTINUA:	INC   IX		;se incremente el apuntador IX
		INC   IY		;se incrementa el apuntador IY
		DJNZ  CICLO		;si no se ha recorrido toda la lista salta a ciclo
		BIT   0,C		;checamos la bandera de cambio
		JP    NZ,BURBUJA	;si hubo cambio, repetimos el proceso
		HALT			;si no hubo cambio, termino la ordenacion
					;se detiene el programa		
CAMBIO:		LD    A,(IX+0)		;se carga A con el dato de IX
		LD    E,(IY+0)		;se carga E con el dato de IX
		LD    (IX+0),E		;se intercambia A por E
		LD    (IY+0),A		;se intercambia E por A
		SET   0,C		;ponemos la bandera de cambio a 1
		JR    CONTINUA		;continuamos con el algoritmo.
;====================================================================================================================

;====================================================================
;=============COMPARA 2 NNUMEROS DE 8 BITS CON SIGNO=================
;====================================================================
;Subrutina que compara 2 numeros de 8 bits con signo.
;Las direcciones de los numeros estan contenidas en
;los registros indice IX e IY.
;Al regresar de la subrutina:
;C=1 si  (IY) < (IX)
;Z=1 si  (IY) = (IX)

CP_S8:	LD	A,(IX+0)	;cargamos en A el primer dato
	AND	80H		;sacamos el bit del signo
	LD	E,A		;cargamos el dato en E
	LD	A,(IY+0)	;cargamos en A el segundo dato
	AND	80H		;sacamos el bit del signo
	AND	E		;se hace una operacion AND con los signos
	JR	NZ,NEGA		;si no es cero, los dos numeros son negativos
	LD	A,(IY+0)	;cargamos en A el segundo dato
	AND	80H		;sacamos su bit de signo
	OR	E		;se hace una operacion OR con los signos
	JR	Z,POSI		;si los dos signos son cero, los numero son positivos
	OR	0FFH		;se pone la bandera Z a 0, indica que no son inguales
	LD	A,(IY+0)	;cargamos el segundo dato en A
	RLA			;guardamos el bit del signo en el acarreo
	RET			;regresamos de la subrutina, si C=1, quiere decir
				;que el dato contenido en IY es negativo por lo
				;tanto es el menor, si no, C=0 y es mayor
NEGA:	LD	A,(IY+0)	;cargamos el segundo dato en A
	NEG			;se saca sucomplemento A2
	LD	E,A		;se guarda en E
	LD	A,(IX+0)	;se carga el primer dato en A
	NEG			;se saca su complemento A2
	CP	E		;comparamos los dos numeros
	RET			;regresamos de la subrutina, Z=1 -> (IX)=(IY)
				;C=1 -> (IX) > (IY)
POSI:	LD	A,(IX+0)	;cargamos el primer dato en A
	LD	E,A		;se guarda en E
	LD	A,(IY+0)	;se carga el segundo dato en A
	CP	E		;comparamos los dos numeros
	RET			;regresamos de la subrutina, Z=1 -> (IX)=(IY)
				;C=1 -> (IX) > (IY)
	
;====================================================================	
	

		ORG  1B00H
		DEFB  024h	;NUMERO DE ELEMENTOS
		
		DEFB  15H	;ELEMENTOS DE LA TABLA;		
		DEFB  02H		
		DEFB  12H
		DEFB  04H
		DEFB  14H
		DEFB  1AH
		DEFB  07H		
		DEFB  0F8H		
		DEFB  0BH
		DEFB  10H
		DEFB  0DH
		DEFB  17H
		DEFB  0FH
		DEFB  19H
		DEFB  11H
		DEFB  0AH
		DEFB  13H		
		DEFB  0CH
		DEFB  16H
		DEFB  08H
		DEFB  18H
		DEFB  05H
		DEFB  09H
		DEFB  0F5H
		DEFB  80H
		DEFB  03H
		DEFB  0F2H
		DEFB  0EH
		DEFB  0F9H
		DEFB  0FAH
		DEFB  0FCH
		DEFB  0A5H
		DEFB  01H
		DEFB  0A9H
		DEFB  06H
		DEFB  0AAH
		
		