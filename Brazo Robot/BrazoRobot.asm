;**Universidad Autonoma de San Luis Potosi**
;*******************************************
;**********Facultad de Ingeniería***********
;*******************************************
;
;=======================================================
;Autor: Alfredo Orozco de la Paz
;	Francisco Eduardo Puente Cortez
;
;Materia: Electronica B
;Semestre: 2011/2012 - II
;
;Programa para controloar un brazo robot mediante
;la PC y el sistema minimo.
;
;
;Se conectan 2 motores a pasos mediante el PA del PPI
;los cuales controlan los 2 motores del brazo.
;
;Al PB del PPI se conecta un motor DC, que mueve la base
;del brazo, y un servomotor que controla la pinza.
;
;En el PC del PPI, se conectan los switches de tope
;los cuales se usan para saber cuando el brazo ya
;llego al tope y no se mueva mas para evitar dañar 
;la estructura y los circuitos.
;
;Los datos de control, para saber que motor se debe mover
;se recibiran por el puerto serie.
;Se ejecuta la interrupcion NMI cuando un dato a leer esta
;disponible en la UART.
;
;PC <- Entrada(Switches)
;PB -> Salida (Al motor DC y al Servomotor)
;PA -> Entrada (A los motores a pasos del brazo)
;
;
;  PA0  PA1  PA2  PA3  PA4  PA5  PA6  PA7
;   M1   M1   M1   M1   M2   M2   M2   M2
;
;  PB0  PB1  PB2  PB3  PB4  PB5  PB6  PB7
;  DC+  DC-  SV+  SV-   NC   NC   NC   NC
;
;  PC0  PC1  PC2  PC3  PC4  PC5  PC6  PC7
;   S1   S2   S3   S4   NC   NC   NC   NC
;
;  Palabra de control DEL PPI: 89h
;
;
;Reloj usado 2 MHz
;Velocidad       Divisor de baudaje
;  2400            0034h  
;  4800		   001Ah
;  9600		   000Dh
;
;
;Reloj usado 3.5 MHz
;Velocidad       Divisor de baudaje
;  2400            005Dh  
;  4800		   002Eh
;  9600		   0017h
;=======================================================

		

		M1	 .equ 6004h
		M2	 .equ 6005h
		MB	 .equ 6006h

		ORG   0000h
		
		;Rutina para programar la UART
;Rutina para programar el PPI		
PGRMPPI:	LD    SP,67FFh  ;Inicializamos el Stack Pointer
		LD    A,080h    ;Se carga la palabra de control para el PPI
		OUT   (03h),A	;Se programa el PPI
		LD    A,0FFH
		OUT   (00H),A
		OUT   (01H),A

		
PGRMUART:	LD    A,80h
		OUT   (0A3h),A
		LD    A,34h	;Divisor de baudaje bajo a 2400b
		OUT   (0A0h),A
		LD    A,00h	;Divisor de baudaje alto
		OUT   (0A1h),A
		LD    A,03h	;8bits de dato, 1 bit stop, sin paridad.
		OUT   (0A3h),A
		LD    A,01h	;Habilitamos la interrupcion de la UART
		OUT   (0A1h),A	;por dato recibido.
		JP    INICIO
		
;Rutina de servicio de interrupcion, se ejecuta
;cuando la UART tiene un dato listo para ser leido.		
		org	66h
		EXX
		EX	AF,AF'
		IN	A,(0A0h)
		CALL	CHECA_COMANDO
		CALL	MUEVE_BRAZO
		EX	AF,AF'
		EXX
		RETN

				

	
		
;PROGRAMA PRINCIPAL		
INICIO:		LD	A,00h
		OUT	(01h),A
		LD	A,88H
		OUT	(00h),A
		LD	A,01h
		LD	(M1),A
		LD	(M2),A		
		
BUCLE:		HALT
		RET

		
;Verifica el dato recibido desde la PC para mover algun motor		
CHECA_COMANDO:
		CP	'A'
		JP	Z,PASO1_MOTOR1	;mueve hacia adelante el motor del brazo
		CP	'B'
		JP	Z,PASO2_MOTOR1	;mueve hacia atras el motor del brazo
		CP	'C'
		JP	Z,PASO1_MOTOR2	;mueve hacia adelante el motor del codo
		CP	'D'
		JP	Z,PASO2_MOTOR2	;mueve hacia atras el motor del codo
		CP	'+'
		JP	Z,SERVO_MAS	;abre la pinza
		CP	'-'
		JP	Z,SERVO_MENOS	;cierra la pinza
		CP	'L'
		JP	Z, BASE_MAS	;mueve la base hacia la izquierda
		CP	'R'
		JP	Z, BASE_MENOS	;mueve la base hacia la derecha
		RET
		

;**********SUBRUTINAS PARA MOVER EL MOTOR DE LA BASE DEL BRAZO**********
;Se mueve el motor de la base un paso en sentido
;de las manecillas del reloj.
PASO1_MOTOR1:	LD	A,(M1)
		CP	08h
		JP	NZ,P1M1
		LD	A,00h
P1M1:		INC	A
		LD	(M1),A		
		RET
		
;Se mueve el motor de la base un paso en contra
;de las manecillas del reloj.		
PASO2_MOTOR1:	LD	A,(M1)
		CP	01h
		JP	NZ,P2M1
		LD	A,09h
P2M1:		DEC	A
		LD	(M1),A		
		RET	
;***********************************************************************


;***************SUBRUTINAS PARA MOVER EL MOTOR DEL BRAZO****************
;Se mueve el motor del brazo un paso en sentido
;de las manecillas del reloj.		
PASO1_MOTOR2:	LD	A,(M2)
		CP	08h
		JP	NZ,P1M2
		LD	A,00h
P1M2:		INC	A
		LD	(M2),A		
		RET
		
;Se mueve el motor del brazo un paso en contra
;de las manecillas del reloj.		
PASO2_MOTOR2:	LD	A,(M2)
		CP	01h
		JP	NZ,P2M2
		LD	A,09h
P2M2:		DEC	A
		LD	(M2),A		
		RET				
;***********************************************************************

SERVO_MAS:	LD	A,04H
		JP	SC
SERVO_MENOS:	LD	A,08H
SC:		OUT	(01H),A
		LD	D,05H	;ESPERAR 5MS
		CALL	Delay_ms
		LD	A,00H
		OUT	(01H),A
		RET
		
BASE_MAS:	LD	A,01H
		JP	SCB
BASE_MENOS:	LD	A,02H
SCB:		OUT	(01H),A
		LD	D,0AH	;ESPERAR 10MS
		CALL	Delay_ms
		LD	A,00H
		OUT	(01H),A
		RET
		
		
MUEVE_BRAZO:	LD	A,(M1)
		LD	BC,TABLA_PASOSM1
		LD	H,0H
		LD	L,A
		ADD	HL,BC
		LD	D,(HL);
		
		LD	A,(M2)
		LD	BC,TABLA_PASOSM2
		LD	H,0H
		LD	L,A
		ADD	HL,BC
		LD	A,(HL);
		OR	D
		OUT	(00h),A
		LD	D,05H	;ESPERAR 5MS
		CALL	Delay_ms
		RET
		



;Subrturina que escribe un dato en la UART para enviarlo
;por el puerto serie
WRUART:		OUT   (0A0h),A
		RET

;Esta rutina de espera, esta hecha para demorar un cierto
;tiempo (en milisegundos).
;
;El tiempo de retardo se especifica en el registro D
;
;Por ejemplo, si se desea esperar 100 ms, el registro
;D se carga con 100 (64h) y a continuacion se hace una
;llamada a la subrutina Delay_ms.

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
			
TABLA_PASOSM1:
		DEFB	01h ;0000 0001
		DEFB	01h ;0000 0001	
		DEFB	03h ;0000 0011	
		DEFB	02h ;0000 0010	
		DEFB	06h ;0000 0110	
		DEFB	04h ;0000 0100	
		DEFB	0Ch ;0000 1100	
		DEFB	08h ;0000 1000	
		DEFB	09h ;0000 1001	
		
TABLA_PASOSM2:
		DEFB	010h ;0001 0000
		DEFB	010h ;0001 0000	
		DEFB	030h ;0011 0000 	
		DEFB	020h ;0010 0000 	
		DEFB	060h ;0110 0000 	
		DEFB	040h ;0100 0000 	
		DEFB	0C0h ;1100 0000 	
		DEFB	080h ;1000 0000 	
		DEFB	090h ;1001 0000 				