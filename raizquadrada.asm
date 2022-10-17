	.data
msg1:	.string "Digite um numero para calcular a raiz quadrada: "
msg2:	.string "A raiz quadrada exata é: "
msg3:	.string "A raiz quadrada aproximada é "

	.text
main:
	la a0, msg1
	li a7, 4
	ecall
	
	li a7, 5
	ecall
	
	li a1, 0
	li a2, 1
	
	j verifica
	
verifica:
	beq a0, zero, exata
	bge a0, a2, lacosub
	blt a0, a2, inexata
	
exata:
	la a0, msg2
	li a7, 4
	ecall
	mv a0, a1
	li a7, 1
	ecall
	
	j final

lacosub:
	sub a0, a0, a2
	addi a2, a2, 2
	addi a1, a1, 1
	
	j verifica

inexata:
	la a0, msg3
	li a7, 4
	ecall
	mv a0, a1
	li a7, 1
	ecall
	
	j final

final: