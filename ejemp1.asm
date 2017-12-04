	
	X .EQU 0FEFEH

	LD  A,0
	LD B,A	
	LD  A,1
	LD  C,A
	LD  A,5
	LD  D,A
	LD  A,0
	LD  E,A
TEST:	
	LD  A,B
	INC A
	LD  (HL),C
	CP  (HL)
	JP  Z,FIN
	CALL  CALCUL
	INC (HL)
	JP TEST 
	JP FIN
CALCUL:
	LD  A,(R)
	ADD A,(X)
	LD  (R),A
	LD  A,(X)
	ADD A,(X)
	LD  (X),A
	RET	
FIN:	.END
	