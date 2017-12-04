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
;=======================================================

		chars  .EQU 6000h ;variable que sirve como contador de
				  ;caracteres.

		ORG   0000h		
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
		
INICIO:		IN    A,(00h)
		BIT   4,A
		JP    Z,INICIO
		LD    E,A
SOLTAR:		IN    A,(00h)
		BIT   4,A
		JP    NZ,SOLTAR
		LD    A,E
		AND   0Fh
		LD    HL,TABLALCD
		LD    E,A
		LD    D,0
		ADD   HL,DE
		CALL  WRLCD
		JP    INICIO
		
		
;Subrutina que escribe un caracter en en LCD
;el caracter esta contenido en la localidad
;de memoria apuntada por HL.
WRLCD:		LD    A,(HL)
		OUT   (01h),A
		CALL  CONTROL2
		LD    A,(chars)
		INC   A
		CP    10H
		CALL  Z,REINICIALINEA
		LD   (chars),A	
		RET				
		HALT

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
		END		