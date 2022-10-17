	.data
vetor:	.word 9, 4, 6, 1, 10, 7, 5, 2, 8, 3
tam:	.word 10
msg1: 	.string "A posicao do menor numero eh: "
	.text
	
main: 
	
	la a0, vetor
	lw a1, tam
	
	jal menor_vetor
	
	j fim

menor_vetor:

	li a3, 1 #indice do menor
	li a5, 1 #indice atual
	lw a2, 0(a0) #valor do menor
	j loop
	
loop:
	addi a5, a5, 1
	bgt a5, a1, retrn
	addi a0, a0, 4
	lw a4, 0(a0) #valor atual
	blt a4, a2, swap
	j loop
swap:
	add a2, a4, zero
	add a3, a5, zero
	j loop

retrn:
	ret

fim:
	la a0, msg1
	li a7, 4
	ecall
	add a0, a3, zero
	li a7, 1
	ecall
