#include <regdef.h>

.data
	panic_msg: .asciiz "Unknown orientation %d"
	ON: .word 0
	OS: .word 1
	OE: .word 2
	OW: .word 3
	RR: .word 1


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
	subu  sp, sp, 24

	.cprestore 16

	# salvando el callee
	sw	fp, 20(sp)
	sw	ra, 24(sp)

	move  fp, sp

	####################### STACK FRAME ######################
	
	# 	+---------------+	
	# 24	|	ra	|	/
	# 	+---------------+
	# 20	|   fp	|	\
	# 	+---------------+	
	# 16	|   gp	|	/
	# 	+---------------+
	# 12	|	a3	|	\
	# 	+---------------+	
	# 08	|  	a2	|	|
	# 	+---------------+	
	# 04	|	a1	|	|
	# 	+---------------+	
	# 00	|	a0	|	/
	# 	+---------------+

    move t0, a0
	move t1, a1
	lw t4, ON
	lw t5, OS
	lw t6, OE
	lw t7, OW
	beq t0, t4, decide_north
	beq t0, t5, decide_south
	beq t0, t6, decide_east
	beq t0, t7, decide_west

decide_north:
	lw t2, OW
	lw t3, OE
	b decide

decide_south:
	lw t2, OE
	lw t3, OW
	b decide

decide_east:
	lw t2, ON
	lw t3, OS
	b decide

decide_west:
	lw t2, OS
	lw t3, ON
	b decide

decide:
	lw t4, RR
	beq t1, t4, go_right
	sw t3, 24(sp)
	b new_orientation_end
go_right:
	sw t2, 24(sp)

new_orientation_end:
	lw v0, 24(sp)
	# restauro callee-saved regs
	lw	gp, 16(sp)
	lw	fp, 20(sp)
	lw	ra, 24(sp)
	# destruyo stack frame
	addu	sp, sp, 24
	# vuelvo a funcion llamante
	jr	ra

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
	#	+---------------+	|	ABA CALLER
	# 44	|		|	|
	#	+---------------+	|
	# 40	|		|	/
	# 	+---------------+
	# 36	|	a2	|	\
	# 	+---------------+	|
	# 32	|	a1	|	|
	# 	+---------------+	|	SRA
	# 28	|	a0	|	|
	# 	+---------------+	|
	# 24	|	ra	|	/
	# 	+---------------+
	# 20	|   fp	|	\
	# 	+---------------+	|	LTA
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

    lw t0, 8(a0)   # ant->o
	lw t1, 28(sp) # ant
    
	# switch
	lw t4, ON
	lw t5, OS
	lw t6, OE
	lw t7, OW
	beq t0, t4, adjust_north
	beq t0, t5, adjust_south
	beq t0, t6, adjust_east
	beq t0, t7, adjust_west
	b panic_label # default

adjust_north:
	# Carga de argumentos para pasar a la función adjust
	lw t2, 4(t1) # ant->y
	
	la a0, 4(t1)  # &ant->y
	subu a1, t2, 1 # ant->y - 1
	lw a2, 36(sp) # height. 
    
	b adjust_asm
adjust_south:
	lw t2, 4(t1) # ant->y

	la a0, 4(t1)  # &ant->y
	addu a1, t2, 1 # ant->y - 1
	lw a2, 36(sp) # height.  

	b adjust_asm

adjust_east:
	lw t2, 0(t1)  # ant->x

    la a0, 0(t1)  # &ant->x
	addu a1, t2, 1 # ant->x + 1
	lw a2, 32(sp) # width

  	b adjust_asm

adjust_west:
	lw t2, 0(t1)  # ant->x

    la a0, 0(t1)  # &ant->x
	subu a1, t2, 1 # ant->x + 1
	lw a2, 32(sp) # width
    
	b adjust_asm

panic_label:
	lw a0, panic_msg
	lw a1, 8(a0)   # ant->o
	
	jal doPanic
	b end_label

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




 
