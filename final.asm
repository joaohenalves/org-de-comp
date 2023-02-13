		.data
matriz_navios:	.word	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
tam:		.word	100

matriz_usuario:	.string	"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
navios:		.string	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"
ql:		.string "\n"
txt_menu:	.string	"1)reiniciar jogo\n2)imprimir matriz_navios\n"
txt_erro:	.string	"valor inválido\n\n"
msg_inseriu:	.string "deu certo\n\n"
msg_erro:	.string "deu erro\n\n"

		.text
main:
################## insere imbarcações
	la 	a0, navios  			# a0 recebe o endereço inicial da string navios
	la	a1, matriz_navios 		# a1 recebe o endereço inicial da matriz navios
	jal	insere_embarcacoes		# chama funçao que insere os navios
	
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
	blt a0,t1,erro	#entrada<1 entao 'erro'
	bgt a0,t3,erro	#entrada>3 entao 'erro'
	
	beq a0,t1,reiniciar
	beq a0,t2,imprime_matriz_navios
	beq a0,t3,jogar
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
	
########################################

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

####################################### insere_embarcacoes

insere_embarcacoes:
	la t0, navios
	lb s0, 0(t0)
	addi s0, s0, -48
	addi t0, t0, 2
	li s11, 9
	li s10, 10
	li s9, 4
	li s8, 1
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
	addi s0, s0, -48
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
	
####################################### imprime_matriz
qbl:
	la a0,ql
	li a7,4
	ecall
	li t3,0		#zera o cont de ql
	li a7,1		#volta o a7 para printar int
	j voltaql
	
imprime_matriz_navios:
	la t0,matriz_navios
	li a7,1
	
	la t1,tam
	lw t1,0(t1)	#t1=100
	li t2,0		#t2=0 contador
	li t3,0		#t3=0 contador quebra de linha
	li t4,10	#t4=10
loop1:
	lw a0,0(t0)
	ecall
	addi t0,t0,4	#+4 endereço
	addi t2,t2,1	#+1 contador
	addi t3,t3,1	#+1 contador quebra de linha
	beq t3,t4,qbl	#se t3 == t4(10)
voltaql:
	blt t2,t1,loop1

	ret
	
jogada:
	li a7, 5
	ecall
	mv s0, a0
	li a7, 5
	ecall
	mv s1, a0
	mv s2, 10
	mv s4, 4
	mul s3, s0, s2
	add s3, s3, s1
	
