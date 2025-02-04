

	@ R0 = basadress för dest
	@ R1 = basadress för src
	@ R2 = size, som är 8 atm
	@ R3 = lokal var i
	@ R4 = temporärregister för data
	@ R5 = temporärregister för indexberäkning
start:	
	LDR	R0,=dst 	@ shortvector
	LDR	R1,=src 	@ intvector
	MOV	R2,#4		@ R2 = 4, sätt antalet element i src[] här
	BL	copyvec
	B	start

copyvec:
	PUSH	{R4,R5}		@ Spillregister
	MOV	R3,#0		@ i = 0
	
copyvec1:
	CMP	R3,R2		@ i < size?
	BGE	copyvec2

	LSL	R5,R3,#2	@ i*4 -> R5
	LDR	R4,[R1,R5]	@ src[i*4] -> R4
	STRH	R4,[R0,R5]	@ Placera första halvan av bitarna i dst[i*2]
	
	LSR	R4,R4,#16	@ Skifta R4 för att få andra halvan av src[i]
	ADD	R5,R5,#2	@ +2 i adressberäkning
	STRH	R4,[R0,R5]	@ Placera andra halvan i nästa tillgängliga adress
				@ dst[2 * i + 2] eftersom vi arbetar med halfword. 

	ADD	R3,R3,#1	@ i++
	B	copyvec1

copyvec2:
	POP	{R4,R5}		@ reset spillregister
	BX	LR

	.ORG	0x30

@ 	Variabler:
@	src = int[]
@	dst = short[]
@	Placera godtycklig mängd element och ändra R2 så att 
@	sizeof src = R2

src:	.WORD 	2,4,6,8
dst:	.SPACE 8

