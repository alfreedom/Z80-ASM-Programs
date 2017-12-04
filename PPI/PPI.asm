;
;
;Programa para Probar el PPI en el Z80
;El programa lee el Puerto B del PPI y almacena
;el dato leido en el registro A, luego desplaza
;el registro A una posicion a la izquierda y
;por ultimo envia el dato rotado al Puerto A
;
;PA = 00h
;PB = 01h
;PC = 02h
;PCTLR= 03h
;

Inicio:	LD		A,082h		; Se carga en el acumulador la palabra de control para el PPI.
		OUT	(03h),A		; Se escribe la palabra de control en el puerto 03h.
Ciclo:	IN		A,(01h)		; Leemos el PB y guardamos su contenido en el acumulador.
		SLA	A		; El dato leído se desplaza  una posición a la izquierda.
		OUT	(00h),A		; Sacamos por PA el dato desplazado.
		JP	Ciclo		; Saltamos a la etiqueta Ciclo, se  repite el proceso indefinidamente.
		END			; Fin del programa.
