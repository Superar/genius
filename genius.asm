INCLUDE Irvine32.inc

COMMENT @ Procedimentos:

LinhaBlocos
PrintLogo
TelaInicial
PrintBlocosMenu
TelaMenu
TelaInstrucoes
PrintQuadradoGrande
main
@

.data

; Formatacao
centralizarHorizontal BYTE 5 DUP (9), 0
centralizarVertical BYTE 10 DUP (0Dh, 0Ah), 0
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

	call LinhaBlocos
	call Crlf
	call LinhaBlocos

	mov edx, OFFSET centralizarVertical
	call WriteString

	call PrintLogo

	call WriteString

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
; Desenha primeira parte da tela de menu
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
; Usa: EAX, EBX, EDX
; ------------------------------------------------------------
	push eax
	push ebx
	push edx

	call Clrscr

TelaMenuJogar:
	call PrintBlocosMenu
	mov edx, OFFSET jogarSelecionado
	call WriteString
	mov edx, OFFSET instruMenu
	call WriteString
	mov ebx, 0
	jmp TelaMenuLeTecla

TelaMenuInstru:
	call PrintBlocosMenu
	mov edx, OFFSET jogarMenu
	call WriteString
	mov edx, OFFSET instruSelecionado
	mov ebx, 1
	call WriteString

TelaMenuLeTecla:
	mov eax, 50
	call Delay

	call ReadKey
	jz TelaMenuLeTecla

	cmp dx, cimaDX
	je TelaMenuJogar

	cmp dx, baixoDX
	je TelaMenuInstru

	cmp dx, enterDX
	je TelaMenuEnter

	cmp dx, escDX
	jne TelaMenuLeTecla
	jmp TelaMenuFim

TelaMenuEnter:
	call TelaInstrucoes
	jmp TelaMenuJogar

TelaMenuFim:

	pop edx
	pop ebx
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
; Usa: EDX, ECX, EAX
; ------------------------------------------------------------
	push edx
	push ecx
	push eax

	mov edx, OFFSET centralizarVertical
	call WriteString

	mov ecx, 8

LinhaQuadrado:
	mov edx, OFFSET centralizarHorizontal
	call WriteString

	mov eax, azul
	shl eax, 4
	or eax, azul
	call SetTextColor

	mov edx, OFFSET quadradoGrande
	call WriteString

	mov eax, preto
	shl eax, 4
	or eax, branco
	call SetTextColor

	loop LinhaQuadrado

	pop eax
	pop ecx
	pop edx

	ret
PrintQuadradoGrande ENDP

main PROC
	;call TelaInicial
	;call TelaMenu
	call PrintQuadradoGrande
	exit
main ENDP
END main
