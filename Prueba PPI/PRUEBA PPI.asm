

	LD A,080h
	OUT (03h),A
	LD A,0FFh
CICLO:  OUT (00h),A
	OUT (01h),A
	OUT (02h),A
	JP CICLO	