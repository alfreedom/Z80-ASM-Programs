;Tarea de Repaso 4 parcial Electronica B
;
;Este programa lee una tecla del teclado matricial
;y lo muestra en el LCD.
;
;El programa lee la tecla mediante interrupciones,
;configuradas en el modo 1, el cual salta a la direccion
;38h, cuando se presente la interrupcion.
;
;PA = ENTRADA DEL TECLADO MATRICIAL
;PB = SALIDA AL BUS DE DATOS DEL DISPLAY
;PC = SALIDA AL BUS DE CONTROL DEL DISPLAY
;
;Orozco de la Paz Alfredo
;Puente Cortez Francisco Eduardo
;Fraga Cordoba José Santos

	
	ORG 00h
	JP   INICIO
	
	ORG  38h
	IN   A,(00h)
	AND  0FH
	LD   HL,TABLALCD
	LD   E,A
	LD   D,0
	ADD  HL,DE
	CALL WRLCD
	EI
	RETI
	
	
INICIO:
	IM    1
	EI
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
	HALT
	
WRLCD:	
	LD    A,(HL)
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