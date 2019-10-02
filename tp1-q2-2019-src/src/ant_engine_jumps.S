#include <regdef.h>

.data
ime: .asciiz "TP1 2Q2019: Implement me!"

.text
.align 2
.globl new_orientation
.ent new_orientation

new_orientation:
    #debugging info: descripcion del stack frame
	.frame $fp, 40, ra		# ver que a lo mejor 40 no es un buen numero

	#bloque para codigo pic
	.set noreorder
	.cpload t9
	.set reorder

	#creo stack frame
	subu	sp, sp, 40

	#bloque para codigo pic
	.cprestore 24

	# salvando el callee
	sw	$fp, 28(sp)
	sw	ra, 32(sp)

	move 	$fp, sp

	####################### STACK FRAME ######################
	
	#	+---------------+
	# 52	|		|	\
	#	+---------------+	|
	# 48	|		|	|
	#	+---------------+	|	ABA CALLER
	# 44	|		|	|
	#	+---------------+	|
	# 40	|	a0	|	/
	# 	+---------------+
	# 36	|		|	\
	# 	+---------------+	|
	# 32	|	ra	|	|
	# 	+---------------+	|	SRA
	# 28	|	fp	|	|
	# 	+---------------+	|
	# 24	|	gp	|	/
	# 	+---------------+
	# 20	|    	|	\
	# 	+---------------+	|	LTA
	# 16	|   	|	/
	# 	+---------------+
	# 12	|		|	\
	# 	+---------------+	|
	# 08	|		|	|
	# 	+---------------+	|	ABA CALLEE
	# 04	|		|	|
	# 	+---------------+	|
	# 00	|		|	/
	# 	+---------------+

    sw a0, 40($fp)
    lw t0, 8($a0)

	##Introducir logica aqui

	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

.end new_orientation

.text
.align 2
.globl move_forward
.ent move_forward
move_forward:
        #debugging info: descripcion del stack frame
	.frame $fp, 40, ra		# ver que a lo mejor 40 no es un buen numero

	#bloque para codigo pic
	.set noreorder
	.cpload t9
	.set reorder

	#creo stack frame
	subu	sp, sp, 40

	#bloque para codigo pic
	.cprestore 24

	# salvando el callee
	sw	$fp, 28(sp)
	sw	ra, 32(sp)

	move 	$fp, sp

	####################### STACK FRAME ######################
	
	#	+---------------+
	# 52	|		|	\
	#	+---------------+	|
	# 48	|		|	|
	#	+---------------+	|	ABA CALLER
	# 44	|		|	|
	#	+---------------+	|
	# 40	|	a0	|	/
	# 	+---------------+
	# 36	|		|	\
	# 	+---------------+	|
	# 32	|	ra	|	|
	# 	+---------------+	|	SRA
	# 28	|	fp	|	|
	# 	+---------------+	|
	# 24	|	gp	|	/
	# 	+---------------+
	# 20	|    	|	\
	# 	+---------------+	|	LTA
	# 16	|   	|	/
	# 	+---------------+
	# 12	|		|	\
	# 	+---------------+	|
	# 08	|	a2	|	|
	# 	+---------------+	|	ABA CALLEE
	# 04	|	a1	|	|
	# 	+---------------+	|
	# 00	|	a0	|	/
	# 	+---------------+

	#guardar a0 a1 y a2 en el stack
    sw a0, 40($fp) #Ver si va aca o en 0($fp)
	sw a1, 4($fp)
	sw a2, 8($fp)

    lw t0, 8(a0)   # ant->o
    beq $t0, north, adjust_aux
	beq $t0, south, adjust_aux2
	beq $t0, east, adjust_aux3
	beq $t0, west, adjust_aux4
	b panic_aux

adjust_aux:
	# Carga de argumentos para pasar a la función adjust
	lw t1, 40(sp) # ant
	lw t2, 4(t1)  # ant->y

    la a0, t2  # &ant->y
	
	subu t2, t1, 1 # ant->y - 1
	lw a1, t2 # ant->y - 1
	lw a2, 8(sp) # height. Esta linea puede no hacer falta porque nunca pisamos el a2 que venis
    la t9, adjust
    jal ra, t9

	b end_label #jump to end_label

adjust_aux2:
	lw t1, 40(sp) # ant
	lw t2, 4(t1)  # ant->y

    la a0, t2  # &ant->y

	addu t2, t1, 1 # ant->y + 1
	lw a1, t2 # ant->y + 1
	lw a2, 8(sp) # height. Esta linea puede no hacer falta porque nunca pisamos el a2 que venis
    la t9, adjust
    jal ra, t9

	b end_label

adjust_aux3:
	lw t1, 40(sp) # ant
	lw t2, 0(t1)  # ant->x

    la a0, t2  # &ant->x

	addu t2, t1, 1 # ant->x + 1
	lw a1, t2 # ant->x + 1
	lw a2, 4(sp) # width
    la t9, adjust
    jal ra, t9

	b end_label

adjust_aux4:
	lw t1, 40(sp) # ant
	lw t2, 0(t1)  # ant->x

    la a0, t2  # &ant->x

	subu t2, t1, 1 # ant->x - 1
	lw a1, t2 # ant->x - 1
	lw a2, 4(sp) # width
    la t9, adjust
    jal ra, t9

	b end_label

panic_label:
	lw t0, 8(a0)   # ant->o
	
	lw a0, #load "Unknown orientation %d"
	lw a1, t0
	la t9, panicd
    jal ra, t9
	b end_label

end_label:
	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

    .end move_forward


.data

north: .asciiz "ON"
south: .asciiz "OS"
east: .asciiz "OE"
west: .asciiz "OW"

 
