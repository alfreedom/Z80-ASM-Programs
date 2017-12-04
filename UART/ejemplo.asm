
		chars  .EQU 6000h ;variable que sirve como contador de
				  ;caracteres.
	        recibido .equ 6001h
		dato     .equ 6003h


		ORG   0000h
		;Rutina para programar la UART
PGRMUART:	LD    A,83h
		OUT   (0A3h),A
		LD    A,0Dh	;Divisor de baudaje bajo
		OUT   (0A0h),A
		LD    A,00h	;Divisor de baudaje alto
		OUT   (0A1h),A
		LD    A,03h	;8bits de dato, 1 bit stop, sin paridad.
		OUT   (0A3h),A

				
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
		
		
		
INICIO:		LD    A,"#"
		CALL  WRUART
		;CALL  WRLCD
		JP    INICIO
		
		
;Subrutina que escribe un caracter en en LCD
;el caracter esta contenido en la localidad
;de memoria apuntada por HL.
WRLCD:		OUT   (01h),A
		CALL  CONTROL2
		LD    A,(chars)
		INC   A
		CP    10H
		CALL  Z,REINICIALINEA
		LD   (chars),A	
		RET				
		HALT
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
		PUSH DE 	;guardamos el par de reigstros DE en la pila
		EXX		;Respaldamos todos los registros, en los
				;registros complementarios.	
		EX  AF,AF'	;guardamos el registro A y el registro de banderas
				;en los registros A' y F'.
		POP DE		;restauramos los registros DE, sacandolo de la pila
CICLO:		LD  BC,0067h	;cargamos BC con 0067h, para demorar 1ms
CICLO2:		DEC BC		;decrementamos BC
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
