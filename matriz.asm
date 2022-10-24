	.data
matriz:	.word 3, 9, 1, 2, 5, 7, 8, 4, 6
tam:	.word 3
queb:	.string "\n"
esp:	.string " "

	.text
main:
	lw s0, tam
	mul t5, s0, s0
	la t1, matriz

ordenar:
	addi s1, s1, 1
	bge s1, t5, loop_ord
	lw t2, 0(t1)
	lw t3, 4(t1)
	bgt t2, t3, swap
	addi t1, t1, 4
	j ordenar
swap:
	mv t4, t3
	mv t3, t2
	mv t2, t4
	sw t2, 0(t1)
	sw t3, 4(t1)
	addi t1, t1, 4
	j ordenar
	
loop_ord:
	mv s1, zero
	addi t5, t5, -1
	la t1, matriz
	beq t5, zero, prepara_print
	j ordenar
	
prepara_print:
	la t1, matriz
	mv s1, zero

imp_mat:
	lw a0, 0(t1)
	li a7, 1
	ecall
	la a0, esp
	li a7, 4
	ecall
	addi t1, t1, 4
	addi s1, s1, 1
	beq s0, s1, loop_print
	j imp_mat

loop_print:
	la a0, queb
	li a7, 4
	ecall
	mv s1, zero
	addi s2, s2, 1
	beq s2, s0, fim
	j imp_mat

fim:
	nop
