;Nombre del Programa: Rutina de retardo en ms (milisegundos)
;Autor: Alfredo Orozco de la Paz
;
;Esta rutina de espera, esta hecha para demorar un cierto
;tiempo (en milisegundos).
;
;El tiempo de retardo se especifica en el registro D
;
;Por ejemplo, si se desea esperar 100 ms, el registro
;D se carga con 100 (64h) y a continuacion se hace una
;llamada a la subrutina Delay_ms.
;
	LD	D,09h 
	CALL Delay_ms  

	HALT

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
	
	
	