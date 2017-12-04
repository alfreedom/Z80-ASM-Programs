;Tarea de Repaso 4 parcial Electronica B
;
;Este programa lee una caracter recibido de la UART
;y lo muestra en el LCD.
;
;El programa lee la el contenido de la uart mediante
;La interrupcion NMI, el cual salta a la direccion
;66h, cuando se presente la interrupcion.
;
;PA = NC
;PB = SALIDA AL BUS DE DATOS DEL DISPLAY
;PC = SALIDA AL BUS DE CONTROL DEL DISPLAY
;
;Orozco de la Paz Alfredo
;Puente Cortez Francisco Eduardo
;Fraga Cordoba José Santos

	
	ORG 00h
	JP   INICIO
	
	ORG  66h
	IN   A,(0A0h)
	CALL WRLCD
	RETN
	
	
INICIO:
	LD    SP,67FFh
	LD    A,38h
	OUT   (01H),A
	CALL  CONTROL1
	LD   A,06h
	OUT  (01H),A
	CALL  CONTROL1
	LD   A,0Fh
	OUT  (01H),A
	CALL  CONTROL1
	LD   A,80h
	OUT  (01H),A
	CALL  CONTROL1
	LD   A,01h
	OUT  (01H),A
	CALL  CONTROL1
	
;Rutina para programar la UART
PGRMUART:	LD    A,80h	;Activacion del DLAB
		OUT   (0A3h),A
		LD    A,10h	;Divisor de baudaje bajo
		OUT   (0A0h),A
		LD    A,00h	;Divisor de baudaje alto
		OUT   (0A1h),A
		LD    A,07h	;8bits de dato, 1 bit stop, sin paridad.
		OUT   (0A3h),A
		LD    A, 01h	;Activacion de interrupcion por dato recibido
		OUT   (0A1h),A
	HALT
	
WRLCD:	
	OUT   (01H),A
	CALL  CONTROL2
	RET
	
CONTROL1:	
	LD    A,00H
	OUT   (02H),A
	CALL  ESPERA
	LD    A,04H
	OUT   (02H),A
	CALL  ESPERA
	LD    A,00H
	OUT   (02H),A
	CALL  ESPERA
	RET
	
CONTROL2:	
	LD    A,02H
	OUT   (02H),A
	CALL  ESPERA
	LD    A,06H
	OUT   (02H),A
	CALL  ESPERA
	LD    A,02H
	OUT   (02H),A
	CALL  ESPERA
	RET
ESPERA:
	LD    D,02H
	PUSH  DE
	EXX
	EX    AF,AF'
	POP   DE
CICLO:	LD    BC,0067H
CICLO2:	DEC   BC
	LD    A,C
	OR    B
	JP    NZ,CICLO2
	EX    AF,AF'
	EXX
	RET	
TABLALCD:
	DEFB	"1"
	DEFB	"2"
	DEFB	"3"
	DEFB	"A"
	DEFB	"4"
	DEFB	"5"
	DEFB	"6"
	DEFB	"B"
	DEFB	"7"
	DEFB	"8"
	DEFB	"9"
	DEFB	"C"
	DEFB	"*"
	DEFB	"0"
	DEFB	"#"
	DEFB	"D"
	END