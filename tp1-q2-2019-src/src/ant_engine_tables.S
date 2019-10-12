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

    la t1, relevant_bounds
    lw t0, 8(a0)   # ant->o
    addu t1, t1, t0 # bound
    la t2, allowed_forward
    addu t3, t0, 1 
    addu t2, t2, t3 # go_forward

allowed_forward:
    b step_north
    b step_south
    b step_east
    b step_west

step_north:
    lw t2, 4(a0) # ant->y
	
	la a0, 4(a0)  # &ant->y
	subu a1, t2, 1 # ant->y - 1
	lw a2, 36(sp) # height. 
    
	b adjust
step_south:
    lw t2, 4(a0) # ant->y

	la a0, 4(a0)  # &ant->y
	addu a1, t2, 1 # ant->y - 1
	lw a2, 36(sp) # height.  

	b adjust
step_east:
    lw t2, 0(a0)  # ant->x

    la a0, 0(a0)  # &ant->x
	addu a1, t2, 1 # ant->x + 1
	lw a2, 32(sp) # width

  	b adjust
step_west:
    lw t2, 0(a0)  # ant->x

    la a0, 0(a0)  # &ant->x
	subu a1, t2, 1 # ant->x + 1
	lw a2, 32(sp) # width
    
	b adjust

adjust:
    jal adjust_asm

end_label:
	
	lw v0, 28(sp) # Devuelvo ant
	# restauro callee-saved regs
	lw	gp, 16(sp)
	lw	fp, 20(sp)
	lw	ra, 24(sp)
	# destruyo stack frame
	addu  sp, sp, 24
	# vuelvo a funcion llamante
	jr	ra

.end move_forward

.data
rotation_rules :
north: .word x,y
south: .word y,x
east: .word a, b
west: .word b, a
