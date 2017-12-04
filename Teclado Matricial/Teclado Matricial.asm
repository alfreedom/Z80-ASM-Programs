;**Universidad Autonoma de San Luis Potosi**
;*******************************************
;**********Facultad de Ingeniería***********
;*******************************************
;============================================
;Autor: Alfredo Orozco de la Paz
;Materia: Electronica B
;
;
;Programa que lee el teclado matricial
;conectado al PC Bajo, con el circuito
;74C922.
;
;PC -> Salida (A un display de 7 Seg.)
;PB -> Salida (sin uso)
;PA <- Entrada (Al las salidas del circuito de teclado)
;  PA0  PA1  PA2  PA3  PA4  PA5  PA6  PA7
;   nc   nc  nc   nc   D0   D1   D2   D3
;Palabra de control: 90h
;=============================================


DISPLAY  .EQU 6000h
		ORG   0000h		
PGRMPPI:	LD    SP,67FFh  ;Inicializamos el Stack Pointer
		LD    A,090h    ;Se carga la palabra de control para el PPI
		OUT   (03h),A	
		LD    A,040h	
		OUT   (02h),A
		
INICIO:		IN    A,(00h)
		BIT   3,A
		JP    Z,INICIO
		LD    E,A
SOLTAR:		IN    A,(00h)
		BIT   3,A
		JP    NZ,SOLTAR
		LD    A,E
		AND   0F0h
		SRL   A
		SRL   A
		SRL   A
		SRL   A
		LD    HL,TABLA7S
		LD    E,A
		LD    D,0
		ADD   HL,DE
		LD    A,(HL)
		OUT   (02h),A
		JP    INICIO		
		HALT

TABLA7S:	
		DEFB   006h  ;1
		DEFB   05bh  ;2
		DEFB   04Fh  ;3
		DEFB   077h  ;A
		DEFB   066h  ;4
		DEFB   06Dh  ;5
		DEFB   0FDh  ;6
		DEFB   07Ch  ;B
		DEFB   047h  ;7
		DEFB   07Fh  ;8
		DEFB   067h  ;9
		DEFB   039h  ;C	
		DEFB   079h  ;E
		DEFB   03Fh  ;0
		DEFB   071h  ;F			
		DEFB   05Eh  ;D
		DEFB   040h  ;guion	
		END


		