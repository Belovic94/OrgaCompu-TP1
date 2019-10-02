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

    sw a0, 40($fp)
    #guardar a0 a1 y a2 en el stack
    lw t0, 8($a0)   # ant->o
    beq $t0, north, adjust_aux

adjust_aux:
    lw a0, 

    la t9, adjust
    jal ra, t9

    .end move_forward

.data

north: .asciiz "ON"
south: .asciiz "OS"
east: .asciiz "OE"
west: .asciiz "OW"

 
