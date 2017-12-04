;*************************************
;Suma binaria de 8 bits
;
;Autor: Alfredo Orozco de la paz
;
;Fecha: 5 de marzo del 2012
;*************************************

loc1 equ 012h
loc2 equ 013h
loc3 equ 014h


	ld	A,(loc1)
	ld	HL,loc2
	add	A,(HL)
	ld	(loc3),A
	