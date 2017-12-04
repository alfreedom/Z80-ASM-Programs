;**Universidad Autonoma de San Luis Potosi**
;*******************************************
;**********Facultad de Ingeniería***********
;*******************************************
;============================================
;Autor: Alfredo Orozco de la Paz
;Materia: Electronica B
;
;
;Programa que corre un bit de izquierda a derecha
;y de derecha a izquierda por todos los puertos del
;PPI, el bit pasa del PA al PC y de regreso.
;
;PA -> Salida
;PB -> Salida
;PC -> Salida
;Palabra de control: 80h
;=============================================
		ORG 00h
		LD A,80h
		OUT (03),A
		LD SP,67FFH
INICIO:		LD  C,00h
IZQUIERDA:	LD  A,01h
CICLOIZQ:	OUT (C),A
		LD  D,0Fh
		CALL Delay_ms
		SLA  A
		JP  NC,CICLOIZQ
		OUT (C),A
		INC C
		LD  A,C
		CP  03h
		JP NZ,IZQUIERDA
		DEC C
DERECHA:	LD A,80h
CICLODER:	OUT (C),A
		LD  D,0FFh
		CALL Delay_ms
		SRL A
		JP  NC,CICLODER
		OUT (C),A
		DEC C
		LD  A,C
		CP 0Fh
		JP NZ,DERECHA
		JP INICIO
		END
;==========================================================
;===================RUTINA DE DELYA========================
;El tiempo de retardo se especifica en el registro D
	

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
	RET		;retorno de la subrutina.
;==========================================================
;==========================================================