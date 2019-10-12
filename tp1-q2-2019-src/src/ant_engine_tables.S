#include <regdef.h>

.data
ime: .asciiz "TP1 2Q2019: Implement me!"

.text
.align 2
.globl new_orientation
.ent new_orientation


new_orientation:
        #debugging info: descripcion del stack frame
	.frame fp, 24, ra 

	#bloque para codigo pic
	.set noreorder
	.cpload t9
	.set reorder

	#creo stack frame
	subu	sp, sp, 24

	.cprestore 16

	# salvando el callee
	sw	fp, 20(sp)
	sw	ra, 24(sp)

	move  fp, sp

	####################### STACK FRAME ######################
	
	#	+---------------+
	# 52	|		|	\
	#	+---------------+	|
	# 48	|		|	|
	#	+---------------+	|	
	# 44	|		|	|
	#	+---------------+	|
	# 40	|		|	/
	# 	+---------------+
	# 36	|	a2	|	\
	# 	+---------------+	|
	# 32	|	a1	|	|
	# 	+---------------+	|	ABA CALLER
	# 28	|	a0	|	|
	# 	+---------------+	|
	# 24	|	ra	|	/
	# 	+---------------+
	# 20	|   fp	|	\
	# 	+---------------+	|	SRA
	# 16	|   gp	|	/
	# 	+---------------+
	# 12	|	a3	|	\
	# 	+---------------+	|
	# 08	|	a2	|	|
	# 	+---------------+	|	ABA CALLEE
	# 04	|	a1	|	|
	# 	+---------------+	|
	# 00	|	a0	|	/
	# 	+---------------+

	#guardar a0 a1 y a2 en el stack
    sw a0, 28(sp) 
	sw a1, 32(sp)
	sw a2, 36(sp)


.end new_orientation

.text
.align 2
.globl move_forward
.ent move_forward
move_forward:
    la a0, ime
    jal doPanic
.end move_forward

.data
rotation_rules :
north: .word x,y
south: .word y,x
east: .word a, b
west: .word b, a
