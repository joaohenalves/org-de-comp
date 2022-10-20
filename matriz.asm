	.data
matriz:	.word 3, 9, 1, 2, 5, 7, 8, 4, 6
tam:	.word 3
queb:	.string "\n"
esp:	.string " "

	.text
main:
	lw s0, tam
	la t1, matriz

imp_mat:
	lw a0, 0(t1)
	li a7, 1
	ecall
	la a0, esp
	li a7, 4
	ecall
	addi t1, t1, 4
	addi s1, s1, 1
	beq s0, s1, loop
	j imp_mat

loop:
	la a0, queb
	li a7, 4
	ecall
	mv s1, zero
	addi s2, s2, 1
	beq s2, s0, fim
	j imp_mat

fim: