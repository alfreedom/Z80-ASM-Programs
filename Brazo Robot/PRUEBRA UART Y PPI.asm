;**Universidad Autonoma de San Luis Potosi**
;*******************************************
;**********Facultad de Ingeniería***********
;*******************************************
;
;=======================================================
;Autor: Alfredo Orozco de la Paz
;Materia: Electronica B
;
;
;Programa que lee el teclado matricial
;conectado al PC Bajo, con el circuito
;74C922, y muestra la tecla presionada en 
;un display de cristal liquido LCD
;
;PC -> Salida (Bus de control del Display LCD)
;PB -> Salida (Bus de datos del Display LCD)
;PA <- Entrada (Al las salidas del circuito de teclado)
;  PA0  PA1  PA2  PA3  PA4  PA5  PA6  PA7
;   nc   nc  nc   DD   D0   D1   D2   D3
;
;  DD = Dato Disponible
;  D0-D3 = Codigo de la tecla
;
;  Palabra de control: 90h
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
		JP    PGRMPPI
		
;Rutina de servicio de interrupcion, se ejecuta
;cuando la UART tiene un dato listo para ser leido.		
		org	66h
		EXX
		EX	AF,AF'
		
		IN	A,(0A0h)
		CALL    		WRUART
		;CALL	CHECA_COMANDO
		;CALL	MUEVE_BRAZO
		
		EX	AF,AF'
		EXX
		RETN

				
;Rutina para programar el PPI		
PGRMPPI:	LD    SP,67FFh  ;Inicializamos el Stack Pointer
		LD    A,080h    ;Se carga la palabra de control para el PPI
		OUT   (03h),A	;Se programa el PPI
	
		
;PROGRAMA PRINCIPAL		
INICIO:		LD	A,00h
		OUT	(00h),A
		OUT	(01h),A
		LD	A,01h
		LD	(M1),A
		LD	(M2),A
		OUT	(00h),A
		
		
BUCLE:		LD	A,0FFH
		OUT	(00H),A
		RET

		
		
CHECA_COMANDO:
		CP	'A'
		JP	Z,PASO1_MOTOR1
		CP	'B'
		JP	Z,PASO2_MOTOR1
		CP	'C'
		JP	Z,PASO1_MOTOR2
		CP	'D'
		JP	Z,PASO2_MOTOR2
		CP	'+'
		JP	Z,SERVO_MAS
		CP	'-'
		JP	Z,SERVO_MENOS
		
		CP	'L'
		JP	Z, IZQ
		CP	'R'
		JP	Z, DER
		RET
		
IZQ:		LD	A,01H
		JP	CONTINUA
DER:		LD	A,02H
CONTINUA:	LD	(MB),A
		JP	MUEVE_BASE
		
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
		;ESPERAR 5MS
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
		;ESPERAR 5 MS
		RET
		
MUEVE_BASE:	
		LD	A,(MB)
		OUT	(01h),A
		;ESPERAR 10 MS
		LD	A,0
		OUT	(01h),A
		LD	(MB),A
		RET


;Subrturina que escribe un dato en la UART para enviarlo
;por el puerto serie
WRUART:		OUT   (0A0h),A
		RET

		
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