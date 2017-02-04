INCLUDE Irvine32.inc


COMMENT @ Procedimentos:

LinhaBlocos
PrintLogo
TelaInicial
PrintBlocosMenu
TelaMenu
TelaInstrucoes
PrintQuadradoGrande
GeraSequencia
PrintSequencia
PrintParteQuadrado
PrintLinhaQuadradosPequenos
PrintQuadradosPequenos
TelaJogo
main
@


.data

; Formatacao
centralizarHorizontal BYTE 5 DUP (9), 0
centralizarVertical BYTE 10 DUP (0Dh, 0Ah), 0
espacamentoQuadrados BYTE 9, 0
azul DWORD 1
verde DWORD 2
vermelho DWORD 0Ch
amarelo DWORD 0Eh
branco DWORD 0Fh
preto DWORD 0

; Teclado
cimaDX WORD 0026h
baixoDX WORD 0028h
enterDX WORD 000Dh
escDX WORD 001Bh
T1DX WORD 0031h
T2DX WORD 0032h
T3DX WORD 0033h
T4DX WORD 0034h

; Tela inicial
bloco BYTE 0DBh, 0DBh, 0DBh, 0DBh, 0
logo BYTE "  ________              .__              ", 0Dh, 0Ah, 5 DUP (9),
		  " /  _____/  ____   ____ |__|__ __  ______ ", 0Dh, 0Ah, 5 DUP (9),
		  "/   \  ____/ __ \ /    \|  |  |  \/  ___/", 0Dh, 0Ah, 5 DUP (9),
		  "\    \_\  \  ___/|   |  \  |  |  /\___ \ ", 0Dh, 0Ah, 5 DUP (9),
		  " \______  /\___  >___|  /__|____//____  >", 0Dh, 0Ah, 5 DUP (9),
		  "        \/     \/     \/              \/ ", 0Dh, 0Ah, 0

creditos BYTE "    Criado por:", 0Dh, 0Ah,
			   "    Marcio Lima Inacio", 0Dh, 0Ah,
			   "    Samara Assis", 0Dh, 0Ah, 0

; Tela de menu
menuTitulo BYTE "    MENU", 3 DUP (0Dh, 0Ah), 0
jogarSelecionado BYTE "    > Jogar", 2 DUP (0Dh, 0Ah), 0
instruSelecionado BYTE "    > Instrucoes", 2 DUP (0Dh, 0Ah), 0
jogarMenu BYTE "      Jogar", 2 DUP (0Dh, 0Ah), 0
instruMenu BYTE "      Instrucoes", 2 DUP (0Dh, 0Ah), 0

; Instrucoes
instrucoesTitulo BYTE "    INSTRUCOES", 3 DUP (0Dh, 0Ah), 0
instrucoesTexto1 BYTE "      O jogo consiste em seguir uma sequencia de cores mostrada na tela", 2 DUP (0Dh, 0Ah),
					  "      Uma cor e apresentada na tela", 2 DUP (0Dh, 0Ah),
					  "      Aperte o numero da cor correspndente", 2 DUP (0Dh, 0Ah),0
instrucoesTexto2 BYTE "      O Genius ira repetir a primeira cor acrescentando mais uma", 2 DUP (0Dh, 0Ah),
					  "      Aperte as cores seguindo a ordem", 2 DUP (0Dh, 0Ah),
					  "      Continue dessa forma, enquanto voce coseguir repetir cada sequencia corretamente", 2 DUP (0Dh, 0Ah),
					  "      Se voce nao repetir uma sequencia corretamente, perde o jogo.", 2 DUP (0Dh, 0Ah),
					  "      Pressione ESC durante a execucao para sair do jogo.", 4 DUP (0Dh, 0Ah), 0
instrucoesSair BYTE "      Pressione Enter para voltar"

; Jogo
quadradoGrande BYTE 20 DUP (0DBh), 0Dh, 0Ah, 0
beep BYTE 7

fila DWORD 100 DUP (?)
filaTam BYTE 0

.code

; ------------------------------------------------------------
LinhaBlocos PROC
; Imprime uma linha de blocos coloridos
; Usa: ECX, EDX, EAX
; ------------------------------------------------------------
	push ecx
	push edx
	push eax

		mov edx, OFFSET bloco

; Desenha 7 blocos de quatro cores alternadas
		mov ecx, 7
LinhaBlocosLoop:
  	mov eax, azul
    call SetTextColor
    call WriteString
    mov eax, verde
    call SetTextColor
    call WriteString
    mov eax, vermelho
    call SetTextColor
    call WriteString
    mov eax, amarelo
    call SetTextColor
    call WriteString
    loop LinhaBlocosLoop

; Retorna a cor para branco
	  mov eax, branco
	  call SetTextColor

	pop eax
	pop edx
	pop ecx

	ret
LinhaBlocos ENDP


; ------------------------------------------------------------
PrintLogo PROC
; Imprime o logo do jogo
; Usa: EDX
; ------------------------------------------------------------
	push edx

    mov edx, OFFSET centralizarHorizontal
    call WriteString
    mov edx, OFFSET logo
    call WriteString

	pop edx

  ret
PrintLogo ENDP


; ------------------------------------------------------------
TelaInicial PROC
; Imprime a tela inicial do jogo
; Usa: EDX, EAX
; ------------------------------------------------------------
	push edx
	push eax

		call Clrscr

; Desenha os blocos no topo da tela
		call LinhaBlocos
		call Crlf
		call LinhaBlocos

; Centarliza e desenha o logo
		mov edx, OFFSET centralizarVertical
		call WriteString

		call PrintLogo

		call WriteString

; Escreve os creditos
		mov edx, OFFSET creditos
		call WriteString

		call Crlf
	  mov eax, 3000
	  call Delay

	pop eax
	pop edx

	ret
TelaInicial ENDP


; ------------------------------------------------------------
PrintBlocosMenu PROC
; Desenha o cabecalho da tela de menu
; Usa: edx
; ------------------------------------------------------------
	push edx

		mov dx, 0
		call Gotoxy

		call LinhaBlocos
		call Crlf
		call LinhaBlocos

		call Crlf
		call Crlf
		mov edx, OFFSET menuTitulo
		call WriteString

	pop edx

	ret
PrintBlocosMenu ENDP


; ------------------------------------------------------------
TelaMenu PROC
; Imprime a tela de menu
; Usa: EAX, ECX, EDX
; ------------------------------------------------------------
	push eax
	push ecx
	push edx

	call Clrscr

; Opcao de Jogar esta selecionada com a seta
TelaMenuJogar:
		call PrintBlocosMenu
		mov edx, OFFSET jogarSelecionado
		call WriteString
		mov edx, OFFSET instruMenu
		call WriteString
		mov ecx, 0
		jmp TelaMenuLeTecla

; Opcao de Instrucoes esta selecionada com a seta
TelaMenuInstru:
		call PrintBlocosMenu
		mov edx, OFFSET jogarMenu
		call WriteString
		mov edx, OFFSET instruSelecionado
		mov ecx, 1
		call WriteString

; Le uma tecla do usuario
TelaMenuLeTecla:
		mov eax, 50
		call Delay

		call ReadKey
		jz TelaMenuLeTecla

; Tecla para cima: Selecionou jogar
		cmp dx, cimaDX
		je TelaMenuJogar

; Tecla para baixo: Selecionou Instrucoes
		cmp dx, baixoDX
		je TelaMenuInstru

; Enter: Selecionou opcao
		cmp dx, enterDX
		je TelaMenuEnter

; ESC: Sai do jogo
		cmp dx, escDX
		jne TelaMenuLeTecla
		jmp TelaMenuFim

; Verifica a selecao salva em ECX
TelaMenuEnter:
		cmp ecx, 0
		je TelaMenuChamarJogo

		call TelaInstrucoes
		jmp TelaMenuJogar

; Depois de sair do jogo, volta ao inicio do menu
TelaMenuChamarJogo:
		call TelaJogo
		jmp TelaMenuJogar

TelaMenuFim:

	pop edx
	pop ecx
	pop eax

	ret
TelaMenu ENDP


; ------------------------------------------------------------
TelaInstrucoes PROC
; Imprime a tela de instrucoes
; Usa: EAX, EDX
; ------------------------------------------------------------
	push eax
	push edx

		call Clrscr

; Imprime cabecalho e instrucoes

		call LinhaBlocos
		call Crlf
		call LinhaBlocos

		call Crlf
		call Crlf
		mov edx, OFFSET instrucoesTitulo
		call WriteString

		mov edx, OFFSET instrucoesTexto1
		call WriteString
		mov edx, OFFSET instrucoesTexto2
		call WriteString
		mov edx, OFFSET instrucoesSair
		call WriteString

; Le tecla. ESC e Enter saem e voltam para o menu
TelaInstruLeTecla:
		mov eax, 50
		call Delay

		call ReadKey
		jz TelaInstruLeTecla

		cmp dx, enterDX
		je TelaInstruSai
		cmp dx, escDX
		jne TelaInstruLeTecla

TelaInstruSai:
		call Clrscr

	pop edx
	pop eax

	ret
TelaInstrucoes ENDP


; ------------------------------------------------------------
PrintQuadradoGrande PROC
; Imprime um quadrado grande centralizado
; Recebe: cor para pintar [EBP + 8]
; Usa: EDX, ECX, EAX
; ------------------------------------------------------------
	push ebp
	mov ebp, esp
	push edx
	push ecx
	push eax

; Centraliza quadrado
		mov edx, OFFSET centralizarVertical
		call WriteString

; Formado por 8 linhas de quadrado, salvo em uma string de bytes
		mov ecx, 8

LinhaQuadrado:
		mov edx, OFFSET centralizarHorizontal
		call WriteString

; Recebe cor de parametro e colore o texto
		mov eax, [ebp + 8]
		shl eax, 4
		or eax, [ebp + 8]
		call SetTextColor

		mov edx, OFFSET quadradoGrande
		call WriteString

; Retorna texto para branco
		mov eax, branco
		call SetTextColor

		loop LinhaQuadrado

	pop eax
	pop ecx
	pop edx
	pop ebp

	ret
PrintQuadradoGrande ENDP


; ------------------------------------------------------------
GeraSequencia PROC
; Adiciona um elemento aleatorio na fila
; Usa: EAX, ECX
; ------------------------------------------------------------
	push eax
	push ecx

; Recebe ultima posicao da fila
		movzx esi, filaTam
		shl esi, 2

; Gera numero aleatorio para escolher cor
		mov eax, 4
		call RandomRange
		cmp eax, 1
		je GeraVerde
		cmp eax, 2
		je GeraVermelho
		cmp eax, 3
		je GeraAmarelo

; Salva cor em EBX
GeraAzul:
		mov ebx, azul
		jmp InsereElemento
GeraVerde:
		mov ebx, verde
		jmp InsereElemento
GeraVermelho:
		mov ebx, vermelho
		jmp InsereElemento
GeraAmarelo:
		mov ebx, amarelo

	; Insere cor na fila e aumenta tamanho
InsereElemento:
		mov fila[esi], ebx
		add filaTam, 1

	pop ecx
	pop eax

	ret
GeraSequencia ENDP


; ------------------------------------------------------------
PrintSequencia PROC
; Desenha elementos de fila na tela
; Usa: EAX, ECX, EDX
; ------------------------------------------------------------
	push eax
	push ecx
	push edx

		movzx ecx, filaTam
		mov esi, 0

; Itera sobre todos os elementos na fila de acordo com o seu tamanho
PrintSequenciaLoop:
; Tempo entre uma cor e outra
		call Clrscr
		mov eax, 500
		call Delay

; Desenha elementos da fila
		push fila[esi]
		call PrintQuadradoGrande
		pop eax

		mov eax, 1500
		call Delay

		add esi, 4
		loop PrintSequenciaLoop

	pop edx
	pop ecx
	pop eax

	ret
PrintSequencia ENDP


; ------------------------------------------------------------
PrintParteQuadrado PROC
; Imprime uma parte de um quadrado pequeno
; Recebe cor a ser pintada [EBP + 8]
; Usa: EDX, EAX
; ------------------------------------------------------------
	push ebp
	mov ebp, esp
	push edx
	push eax

; Muda a cor
		mov eax, [ebp + 8]
		shl eax, 4
		or eax, [ebp + 8]
		call SetTextColor

	; Imprime dois blocos
		mov edx, OFFSET bloco
		call WriteString
		call WriteString

	; Retorna texto para o branco
		mov eax, branco
		call SetTextColor

	pop eax
	pop edx
	pop ebp

	ret
PrintParteQuadrado ENDP


; ------------------------------------------------------------
PrintLinhaQuadradosPequenos PROC
; Imprime uma linha com quatro partes de quadrados pequenos
; Usa: EDX, EAX
; ------------------------------------------------------------
	push EDX
	push EAX

		push azul
		call PrintParteQuadrado
		pop eax
		mov edx, OFFSET espacamentoQuadrados
		call WriteString

		push verde
		call PrintParteQuadrado
		pop eax
		mov edx, OFFSET espacamentoQuadrados
		call WriteString

		push vermelho
		call PrintParteQuadrado
		pop eax
		mov edx, OFFSET espacamentoQuadrados
		call WriteString

		push amarelo
		call PrintParteQuadrado
		pop eax
		mov edx, OFFSET espacamentoQuadrados
		call WriteString

		call Crlf

	pop EAX
	pop EAX

		ret
PrintLinhaQuadradosPequenos ENDP


; ------------------------------------------------------------
PrintQuadradosPequenos PROC
; Imprime quatro quadrados pequenos coloridos
; Usa: ECX, EDX, EAX
; ------------------------------------------------------------
	push ecx
	push edx
	push eax

		call Clrscr

		mov edx, OFFSET centralizarVertical
		call WriteString

; Cada quadrado e formado de 3 linhas de 2 blocos
		mov ecx, 3
QuadradosPequenosLoop:
		mov edx, OFFSET espacamentoQuadrados
		call WriteString
		call WriteString
		call PrintLinhaQuadradosPequenos
		loop QuadradosPequenosLoop

	pop eax
	pop edx
	pop ecx

	ret
PrintQuadradosPequenos ENDP


; ------------------------------------------------------------
TelaJogo PROC
; Procedimento principal da logica do jogo
; Usa: EAX, EDX, ECX, EBX
; ------------------------------------------------------------
	push eax
	push edx
	push ecx
	push ebx
		call Randomize

; Desenha a sequencia e os quadrados pequenos para selecao
JogoInicio:
		call Clrscr
		call GeraSequencia
		call PrintSequencia
		call PrintQuadradosPequenos

; Contador de quantos elementos foram lidos do usuario
		mov ecx, 0

TelaJogoLeTecla:
		mov eax, 50
		call Delay

		call ReadKey
		jz TelaJogoLeTecla

		cmp dx, T1DX
		je JogoLeuAzul

		cmp dx, T2DX
		je JogoLeuVerde

		cmp dx, T3DX
		je JogoLeuVermelho

		cmp dx, T4DX
		jne TelaJogoLeTecla
		mov ebx, amarelo
		jmp JogoVerificacao

; Atribui cor lida ao registrador ebx
JogoLeuAzul:
		mov ebx, azul
		jmp JogoVerificacao
JogoLeuVerde:
		mov ebx, verde
		jmp JogoVerificacao
JogoLeuVermelho:
		mov ebx, vermelho

; Compara a cor do elemento lido (em EBX) com a posicao atual na fila (ECX)
JogoVerificacao:
		mov al, beep
		call WriteChar
		shl ecx, 2
		cmp fila[ecx], ebx
		jne JogoFim
		shr ecx, 2

		add ecx, 1

; Verifica se a fila acabou
		cmp cl, filaTam
; Fila nao acabou, le proximo elemento
		jne TelaJogoLeTecla
; Fila acabou, reinicia sequencia com novo elemento
		jmp JogoInicio

JogoFim:

; Reinicia fila
		mov filaTam, 0
		call Clrscr

	pop ebx
	pop ecx
	pop edx
	pop eax

	ret
TelaJogo ENDP


main PROC
	call TelaInicial
	call TelaMenu

	exit
main ENDP
END main
