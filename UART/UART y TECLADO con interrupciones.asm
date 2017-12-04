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

		chars  .EQU 6000h ;variable que sirve como contador de
				  ;caracteres.
	        recibido .equ 6001h
		dato     .equ 6003h


		ORG   0000h
		IM    1
		;EI
		;Rutina para programar la UART
PGRMUART:	LD    A,80h
		OUT   (0A3h),A
		LD    A,34h	;Divisor de baudaje bajo a 2400b
		OUT   (0A0h),A
		LD    A,00h	;Divisor de baudaje alto
		OUT   (0A1h),A
		LD    A,03h	;8bits de dato, 1 bit stop, sin paridad.
		OUT   (0A3h),A
		LD    A,01h
		OUT   (0A1h),A
		JP    PGRMPPI
		
		org   38h
		call  ENVIATECLA
		EI
		RETI
		
		org   66h
		EXX
		EX    AF,AF'
		IN    A,(0A0h)
	        CALL  WRLCD
		EX    AF,AF'
		EXX
		RETN

				
;Rutina para programar el PPI		
PGRMPPI:	LD    SP,67FFh  ;Inicializamos el Stack Pointer
		LD    A,090h    ;Se carga la palabra de control para el PPI
		OUT   (03h),A	;Se programa el PPI
		LD    A,00h	;Se incializa el contador de caracteres a 0
		LD    (chars),A
		

	
;Subrutina para programar el LCD
PGRMLCD:	LD    A,38H
		OUT   (01H),A
		CALL  CONTROL1
		LD    A,06H
		OUT   (01H),A
		CALL  CONTROL1
		LD    A,0FH
		OUT   (01H),A
		CALL  CONTROL1		
		LD    A,80H
		OUT   (01H),A
		CALL  CONTROL1
		LD    A,01H
		OUT   (01H),A
		CALL  CONTROL1	
		JP    INICIO
		
		
;PROGRAMA PRINCIPAL		
INICIO:		IN    A,(00h)
		BIT   3,A
		CALL  NZ,ENVIATECLA
		JP    INICIO
		HALT
;PROGRAMA PRINCIPAL
		
ENVIATECLA:	LD    E,A		
SOLTAR:		IN    A,(00h)
		BIT   3,A
		JP    NZ,SOLTAR
		LD    A,E
		AND   0F0h
		SRL   A
		SRL   A
		SRL   A
		SRL   A
		LD    HL,TABLALCD
		LD    E,A
		LD    D,0
		ADD   HL,DE
		LD    A,(HL)
		CALL  WRUART
		RET

		
		
;Subrutina que escribe un caracter en en LCD
;el caracter esta contenido en la localidad
;de memoria apuntada por HL.
WRLCD:		OUT   (01h),A
		CALL  CONTROL2		
		RET	
;Subrturina que envia un dato a la uart para enviarlo
;por el puerto serie
WRUART:		OUT   (0A0h),A
		RET

;Subrutina que regresa el cursor a la primera posicion
;del renglon 1.
REINICIALINEA:	LD    A,80H
		OUT   (01H),A
		CALL  CONTROL1
		LD    A,0		
		RET

;Subrutina que activa las señales para escribir una
;palabra de control en el LCD		
CONTROL1:	LD	A,00h
		OUT	(02h),A
		CALL	ESPERA
		LD	A,04h
		OUT	(02h),A
		CALL	ESPERA
		LD	A,00h
		OUT	(02h),A
		CALL	ESPERA
		RET
		
;Subrutina que activa las señales para escribir
;un caracter en el LCD
CONTROL2:	LD	A,02h
		OUT	(02h),A
		CALL	ESPERA
		LD	A,06h
		OUT	(02h),A
		CALL	ESPERA
		LD	A,02h
		OUT	(02h),A
		CALL	ESPERA
		RET

;Subrutina que demora 2ms, para escribir palabras de 
;control y caracteres en el LCD
ESPERA: 	LD   D,02H		
CICLO:		LD  BC,0067h	;cargamos BC con 0067h, para demorar 1ms
CICLO2:		DEC BC		;decrementamos BC
		LD  A,C		;cargamos C en A para para compara si BC es 0
		OR  B		;comparamos a con B
		JP  NZ,CICLO2	;si no es cero, saltamos a ciclo 2;
		DEC D		;decrementamos D (contador de milisegundos)
		JP  NZ,CICLO	;si no es cero, saltamos a ciclo1
		RET		;retorno de la subrutina.
		
		
;Tabla con los caracteres que se mostraran en el LCD
;dependiendo de la tecla que se haya presionado
TABLALCD:	
		DEFB   "1"  ;1
		DEFB   "2"  ;2
		DEFB   "3"  ;3
		DEFB   "A"  ;A
		DEFB   "4"  ;4
		DEFB   "5"  ;5
		DEFB   "6"  ;6
		DEFB   "B"  ;B
		DEFB   "7"  ;7
		DEFB   "8"  ;8
		DEFB   "9"  ;9
		DEFB   "C"  ;C	
		DEFB   "*"  ;*
		DEFB   "0"  ;0
		DEFB   "#"  ;#			
		DEFB   "D"  ;D
		DEFB   "-"  ;guion	
		END		