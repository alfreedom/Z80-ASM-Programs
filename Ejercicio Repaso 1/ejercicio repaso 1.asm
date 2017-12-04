;Ejercicio 1 de la tarea de repaso.
;
;El programa debe encontrar el numero mas
;pequeño de una lista de numeros de 16 bits
;sin signo que estan en localidades consecutivas
;de memoria.
;
;la primera direccion se encuentra en las localidades
;1900h y 1901h, el numero de elementos del arreglo
;esta en la localidad 1902h, el elemento mas pequeño 
;se guarda en la localidad 1903.

	 ORG	0000h
	 LD	SP,67FFh
	 LD 	HL,1902h
	 LD	B,(HL)
	 dec    B
	 LD 	IX,1900h
	 LD	H,(IX+1)
	 LD	L,(IX+0)	
	 PUSH 	HL
	 DEC	IX
	 DEC	IX
CICLO:   POP	HL
	 LD 	C,H
	 LD 	A,(IX+1)
	 CP 	C
	 JP 	C,A_MENOR
	 JP 	Z,IGUALES
	 PUSH	HL
	 DEC 	IX
	 DEC	IX
CONT:	 DJNZ	CICLO
	 POP	HL
	 LD	(1903h),HL
	 LD	A,(1903h)
	 OUT	(00h),A
	HALT
A_MENOR: LD	H,(IX+1)
	 LD	L,(IX+0)	
	 PUSH 	HL
	 DEC	IX
	 DEC	IX
	 JP	CONT
IGUALES: LD 	C,L
	 LD	A,(IX+0)
	 CP 	C
	 JP	C,A_MENOR
	 PUSH 	HL
	 DEC 	IX
	 DEC	IX
	 JP 	CONT
	
	org  18EEh
	DEFW 0010h
	DEFW 0034h
	DEFW 0009h
	DEFW 0002h
	DEFW 0030h
	DEFW 0007h
	DEFW 0045h
	DEFW 0005h
	DEFW 0009h
	DEFW 0006h
	DEFB 000Ah
	
	
	




