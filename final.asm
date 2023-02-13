			.data
matriz_navios:		.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
tam:			.word	100

matriz_usuario:		.string	"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
navios:			.string	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"
ql:			.string "\n"
txt_menu:		.string	"1)reiniciar jogo\n2)imprimir matriz_navios\n3)atirar\n4)imprimir matriz_usuario\n"
txt_erro:		.string	"valor inválido\n\n"
indice_imprime:		.string "  0 1 2 3 4 5 6 7 8 9\n"
espaco:			.string " "
msg_inseriu:		.string "deu certo\n\n"
msg_erro:		.string "deu erro\n\n"
msg_tiro_certo:		.string "Você acertou!\n\n"
msg_tiro_err:		.string "Você errou!\n\n"
msg_tiro_rep:		.string "Essa posição já foi atingida!\n\n"

		.text
main:
################## insere imbarcações
	jal	insere_embarcacoes	# chama funçao que insere os navios
	
################## menu
menu:
	li a7,4
	la a0,txt_menu
	ecall		#imprime o menu
	li a7,5
	ecall		#le a seleçao do menu
	
	li t1,1
	li t2,2
	li t3,3
	li t4,4
	blt a0,t1,erro	#entrada<1 entao 'erro'
	bgt a0,t4,erro	#entrada>4 entao 'erro'
	
	beq a0,t1,reiniciar
	beq a0,t2,imprime_matriz_navios
	beq a0,t3,jogada
	beq a0,t4,imprime_matriz_usuario
erro:
	li a7,4
	la a0,txt_erro
	ecall
	j menu
	
################## fim do programa
fim:	
	nop
	li   a7, 10
	ecall
	
################## reiniciar

reiniciar:
	la t1, matriz_navios
	la t2, matriz_usuario
	li t3, 126
	li t4, 0
	li t5, 100
	j loop_reinicia

loop_reinicia:
	beq t4, t5, fim_reinicia
	sw zero, 0(t1)
	sb t3, 0(t2)
	addi t1, t1, 4
	addi t2, t2, 1
	addi t4, t4, 1
	j loop_reinicia

fim_reinicia:
	jal insere_embarcacoes
	j menu

################## insere_embarcacoes
insere_embarcacoes:
	la t0, navios
	lb s0, 0(t0)
	addi s0, s0, -48
	addi t0, t0, 2
	li s11, 9
	li s10, 10
	li s9, 4
	li s8, 2
	j verifica_dimensoes
	
verifica_dimensoes:
	beqz, s0, comeca_inserir
	addi s0, s0, -1
	lb s1, 0(t0)
	addi s1, s1, -48
	lb s2, 2(t0)
	beqz s1, verifica_validade_hor
	bgtz s1, verifica_validade_vert
	
verifica_validade_vert:
	lb s3, 4(t0)
	add s2, s2, s3
	addi s2, s2, -96
	bgt s2, s11, invalido
	addi t0, t0, 8
	j verifica_dimensoes
			
verifica_validade_hor:
	lb s3, 6(t0)
	add s2, s2, s3
	addi s2, s2, -96
	bgt s2, s11, invalido
	addi t0, t0, 8
	j verifica_dimensoes
	
invalido: 
	la a0, msg_erro
	li a7, 4
	ecall
	
comeca_inserir:
	la t0, navios
	lb s0, 0(t0)
	addi s0, s0, -47
	addi t0, t0, 2
	j verifica_orientacao
	
verifica_orientacao:
	lb s1, 0(t0)
	addi s1, s1, -48
	lb s2, 2(t0)
	addi s2, s2, -48
	lb s3, 4(t0)
	addi s3, s3, -48
	lb s4, 6(t0)
	addi s4, s4, -48
	beqz s1, insere_hor
	bgtz s1, insere_vert
	
insere_hor:
	beqz s2, inseriu
	la t1, matriz_navios
	addi s2, s2, -1
	mul s5, s3, s10
	add s5, s5, s4
	mul s5 s5, s9
	add t1, t1, s5
	lw s6, 0(t1)
	bnez s6, invalido
	sw s8, 0(t1)
	addi s4, s4, 1
	j insere_hor
	
insere_vert:
	beqz s2, inseriu
	la t1, matriz_navios
	addi s2, s2, -1
	mul s5, s3, s10
	add s5, s5, s4
	mul s5 s5, s9
	add t1, t1, s5
	lw s6, 0(t1)
	bnez s6, invalido
	sw s8, 0(t1)
	addi s3, s3, 1
	j insere_vert
	
inseriu:
	beq s0, s8, fim_insercao
	addi s8, s8, 1
	addi t0, t0, 8
	j verifica_orientacao
	
	
fim_insercao:
	la a0, msg_inseriu
	li a7, 4
	ecall
	ret

###################### jogada
	
jogada:
	li a7, 5
	ecall
	mv s0, a0
	li a7, 5
	ecall
	la t0, matriz_navios
	la t1, matriz_usuario
	mv s1, a0
	li s2, 10
	li s4, 4
	li s6, -1
	li s7, 88
	li s8, 79
	mul s3, s0, s2
	add s3, s3, s1
	mul s3, s3, s4
	add t0, t0, s3
	div s3, s3, s4
	add t1, t1, s3
	lw s5, 0(t0)
	bgtz s5, tiro_certo
	beqz s5, tiro_errado
	beq s5, s6, tiro_repetido
	blt s5, s6, tiro_repetido
	
tiro_certo:
	mul s5, s5, s6
	sw s5, 0(t0)
	sb s7, 0(t1)
	la a0, msg_tiro_certo
	li a7, 4
	ecall
	j menu
	
tiro_errado:
	la a0, msg_tiro_err
	li a7, 4
	ecall
	sw s6, 0(t0)
	sb s8, 0(t1)
	j menu
	
tiro_repetido:
	la a0, msg_tiro_rep
	li a7, 4
	ecall
	j menu
	
################## imprime_matriz_navios
qbl:
	la a0,ql
	li a7,4
	ecall
	li t3,0		#zera o cont de ql
	
	li t6,10	#limite para imprimir o indice
	addi t5,t5,1	#soma 1 no contador do indice de linha
	beq t5,t6,sai_ql
	mv a0,t5	#copia o valor atual do contador do indice de linha
	li a7,1
	ecall		#imprime o indice atual
	la a0,espaco	
	li a7,4
	ecall		#imprime o espaço
sai_ql:
	j voltaql
	
imprime_matriz_navios:
	la a0,indice_imprime
	li a7,4
	ecall		#imprime os indices de coluna
	
	la t0,matriz_navios
	li a7,1
	
	la t1,tam
	lw t1,0(t1)	#t1=100 tamanho da matriz
	li t2,0		#t2=0 contador
	li t3,0		#t3=0 contador quebra de linha
	li t4,10	#t4=10 limite para quebra de linha, limite indice de linha
	li t5,0		#t5=0 contador indice de linha
	
	mv a0,t5
	li a7,1
	ecall
	la a0,espaco
	li a7,4
	ecall
loop1:
	lw a0,0(t0)
	li a7,1
	ecall
	la a0,espaco
	li a7,4
	ecall
	addi t0,t0,4	#+4 endereço
	addi t2,t2,1	#+1 contador
	addi t3,t3,1	#+1 contador quebra de linha
	beq t3,t4,qbl	#se t3 == t4(10)
voltaql:
	blt t2,t1,loop1	#se contador<100

	ret

################## imprime_matriz_usuario
qbl_u:
	la a0,ql
	li a7,4
	ecall
	li t3,0		#zera o cont de ql
	
	li t6,10	#limite para imprimir o indice
	addi t5,t5,1	#soma 1 no contador do indice de linha
	beq t5,t6,sai_ql
	mv a0,t5	#copia o valor atual do contador do indice de linha
	li a7,1
	ecall		#imprime o indice atual
	la a0,espaco	
	li a7,4
	ecall		#imprime o espaço
sai_ql_u:
	j voltaql_u
	
imprime_matriz_usuario:
	la a0,indice_imprime
	li a7,4
	ecall		#imprime os indices de coluna
	
	la t0,matriz_usuario
	li a7,11
	
	la t1,tam
	lw t1,0(t1)	#t1=100 tamanho da matriz
	li t2,0		#t2=0 contador
	li t3,0		#t3=0 contador quebra de linha
	li t4,10	#t4=10 limite para quebra de linha, limite indice de linha
	li t5,0		#t5=0 contador indice de linha
	
	mv a0,t5
	li a7,1
	ecall		#imprime o primeiro indice de linha
	la a0,espaco
	li a7,4
	ecall		#imprime espaço
loop1_u:
	lb a0,0(t0)
	li a7,11
	ecall
	la a0,espaco
	li a7,4
	ecall
	addi t0,t0,1	#+1 endereço
	addi t2,t2,1	#+1 contador
	addi t3,t3,1	#+1 contador quebra de linha
	beq t3,t4,qbl_u	#se t3 == t4(10)
voltaql_u:
	blt t2,t1,loop1_u	#se contador<100

	ret
