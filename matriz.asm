	.data
matriz:	.word 3, 9, 1, 2, 5, 7, 8, 4, 6
tam:	.word 3
queb:	.string "\n"
esp:	.string " "
det:	.string "O determinante da matriz é: "
impsv:	.string "Impossivel calcular o determinante!"

	.text
		
	
main:
	la t1, matriz #t1 será usado para guardar o endereço da matriz na ordenacao, no print da matriz e no calc do determinante.
	
inicializa_bubble_sort:
	mv s1, zero #reseta o reg s1 para o bubble sort
	lw s0, tam #Tamanho da linha ou coluna da matriz (matriz quadrada sempre)
	mul t5, s0, s0 #Guarda o total de numeros existentes na matriz, matriz 3x3 = 9 numeros, para o loop do bubble sort
	j ordenar
	
ordenar:
	#Algoritmo utilizado: Bubble Sort
	addi s1, s1, 1 #loop
	bge s1, t5, loop_ord #Verifica se chegou ao final de cada iteracao do loop
	lw t2, 0(t1) #Carrega os valores a serem verificados
	lw t3, 4(t1)
	bgt t2, t3, swap #Se o anterior for maior, troca
	addi t1, t1, 4 #Passa para o proximo valor
	j ordenar
swap:
	sw t3, 0(t1) #Troca os valores
	sw t2, 4(t1)
	addi t1, t1, 4 #Passa para o proximo valor
	j ordenar #Retorna ao loop
	
loop_ord:
	mv s1, zero #Reseta o reg s1 para reiniciar o loop
	addi t5, t5, -1 #A cada iteracao do loop um elemento da matriz ao final estara ordenado, entao o proximo loop deve ficar menor 1 posicao
	la t1, matriz #Ao final de cada iteracao, recarrega o endereco do primeiro elemento da matriz em t1
	beq t5, zero, inicializa_print #Se t5 for igual a zero, isso significa que a ordenacao foi finalizada.
	j ordenar #Se t5 nao for igual a zero, a ordenacao continua
	
inicializa_print:
	la t1, matriz #Recarrega o end da matriz para a funcao que imprime
	mv s1, zero #Reseta o reg s1 para o print

imp_mat:
	lw a0, 0(t1) #Carrega e printa o valor
	li a7, 1
	ecall
	la a0, esp #Printa um espaco
	li a7, 4
	ecall
	addi t1, t1, 4 #Anda 4 bytes na memoria
	addi s1, s1, 1 #Incrementa loop
	beq s0, s1, loop_print #Vai para o rotulo que imprime a quebra de linha
	j imp_mat

loop_print:
	la a0, queb #Imprime uma quebra de linha
	li a7, 4
	ecall
	mv s1, zero
	addi s2, s2, 1
	beq s2, s0, prepara_determinante #Se acabou de printar a matriz, vai pro calculo do determinante
	j imp_mat #Continua imprimindo a matriz caso nao tenha acabado	

prepara_determinante:
	la t1, matriz #recarrega o end da mat
	j determinante

determinante:
	li t2, 2 #para verificar o tamanho da mat
	li t3, 3 #para verificar o tamanho da mat
	mv s1, zero #reseta o reg s1
	beq s0, t3, det_3x3 #Pula para o rotulo que calcula o det da mat se for 3x3
	bne s0, t2, imp_calc #Se a mat nao for 2x2 e nem 3x3, nao calcula
	
	#Cacula o det da mat 2x2
	lw t4, 0(t1)
	lw t5, 12(t1)
	mul s1, t4, t5
	lw t4, 4(t1)
	lw t5, 8(t1)
	mul t4, t4, t5
	sub s1, s1, t4
	
	#Imprime o resultado
	la a0, det
	li a7, 4
	ecall
	mv a0, s1
	li a7, 1
	ecall
	j fim
	
det_3x3:
	# + (x[0][0] * x[1][1] * x[2][2])
	lw t4, 0(t1)
	lw t5, 16(t1)
	mul t4, t4, t5
	lw t5, 32(t1)
	mul t4, t4, t5
	add s1, s1, t4
	
	# + (x[0][1] * x[1][2] * x[0][2])
	lw t4, 4(t1)
	lw t5, 20(t1)
	mul t4, t4, t5
	lw t5, 24(t1)
	mul t4, t4, t5
	add s1, s1, t4
	
	# + (x[0][2] * x[0][1] * x[2][1])
	lw t4, 8(t1)
	lw t5, 12(t1)
	mul t4, t4, t5
	lw t5, 28(t1)
	mul t4, t4, t5
	add s1, s1, t4
	
	# - (x[0][2] * x[1][1] * x[2][0])
	lw t4, 8(t1)
	lw t5, 16(t1)
	mul t4, t4, t5
	lw t5, 24(t1)
	mul t4, t4, t5
	sub s1, s1, t4
	
	# - (x[0][0] * x[0][2] * x[2][1])
	lw t4, 0(t1)
	lw t5, 20(t1)
	mul t4, t4, t5
	lw t5, 28(t1)
	mul t4, t4, t5
	sub s1, s1, t4
	
	# - (x[0][1] * x[1][0] * x[2][2])
	lw t4, 4(t1)
	lw t5, 12(t1)
	mul t4, t4, t5
	lw t5, 32(t1)
	mul t4, t4, t5
	sub s1, s1, t4
	
	#Imprime o resultado
	la a0, det
	li a7, 4
	ecall
	mv a0, s1
	li a7, 1
	ecall
	j fim

imp_calc:
	#Printa a msg de impossivel calcular
	la a0, impsv
	li a7, 4
	ecall
	j fim
fim:

	nop
