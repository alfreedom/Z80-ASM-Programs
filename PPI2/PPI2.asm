;============================================
;**Universidad Autonoma de San Luis Potosi**
;*******************************************
;**********Facultad de Ingeniería***********
;*******************************************
;============================================
;Autor: Alfredo Orozco de la Paz
;Materia: Electronica B
;
;
;Programa de corrimientos con el
;PPI
;
;PA -> Salida
;PB <- Entrada
;PC ->Salida
;Palabra de control: 82h
;=============================================

PCTRL	EQU	82h
PA	EQU	00h
PB	EQU	01h
PC	EQU	02h
PGRM	EQU	03h


INICIO:	LD	A,PCTRL
	OUT	(PGRM),A
CARGA:	IN	A,(PB)
CICLO:	SLA	A
	OUT	(PA),A
	JP	NZ,CICLO
	JP	CARGA
	END