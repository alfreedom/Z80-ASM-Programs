;Programa que simula un cronometro que
;cuenta en decimas de segundo, al inicio
;muestra ceros y el conteo comienza cuando
;se presione el push button conectado al
;PA0 (bit 0 del PA del PPI), y termina de
;contar cuando se presione el push button
;conectado al PA1 (bit 1 del PA del PPI).
;
;El retardo de conteo se hace mediante una
;subrutina de delay, la cual demora los
;milisegundos definidos en el registro C,
;cada 100 milisegundos se incrementa un
;contador de 16 bits, al presionar el boton
;de parada, el conteo se guarda en memoria,
;y la variable de conteo se reinicia a 0.


	TIEMPO .EQU	6800H

	ORG	0000h
	LD	SP,67FFH;
	LD	A,90h		;SE PROGRAMA EL PPI
	OUT	(03H),A		
		
INICIO:	IN	A,(00H)
	BIT	0,A
	JP	Z,INICIO
	LD	D,25
	CALL	Delay_ms
SUELTAI: IN	A,(00H)
	BIT	0,A
	JP	NZ,SUELTAI
	LD	D,25
	CALL	Delay_ms
	LD	HL,0000H
	CALL 	CUENTA
	JP	INICIO
	
CUENTA: INC	HL
	LD	D,100
	CALL	Delay_ms
	IN	A,(00H)
	BIT	1,A
	JP	Z,CUENTA
	LD	D,25
	CALL	Delay_ms
SUELTAF: IN	A,(00H)
	BIT	0,A
	JP	NZ,SUELTAF
	LD	D,25
	CALL	Delay_ms
	LD	(TIEMPO),HL
	RET
	
;*************************RUTINA DE DELAY************************************
Delay_ms: PUSH DE 	;guardamos el par de reigstros DE en la pila
	EXX		;Respaldamos todos los registros, en los
			;registros complementarios.	
	EX  AF,AF'	;guardamos el registro A y el registro de banderas
			;en los registros A' y F'.
	POP DE		;restauramos los registros DE, sacandolo de la pila
CICLO:	LD  BC,0067h	;cargamos BC con 0067h, para demorar 1ms
CICLO2:	DEC BC		;decrementamos BC
	LD  A,C		;cargamos C en A para para compara si BC es 0
	OR  B		;comparamos a con B
	JP  NZ,CICLO2	;si no es cero, saltamos a ciclo 2;
	DEC D		;decrementamos D (contador de milisegundos)
	JP  NZ,CICLO	;si no es cero, saltamos a ciclo1
	EX  AF,AF'	;restauramos el acumulador y el registro de
			;banderas
	EXX		;restauramos todos los registros guardados en
			;los registros complementariso.
	RET	
	HALT