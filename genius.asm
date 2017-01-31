; Biblioteca Irvine

INCLUDE Irvine32.inc

.data

; Formatacao
centralizarHorizontal BYTE 5 DUP (9), 0
centralizarVertical BYTE 10 DUP (0Dh, 0Ah), 0
azul DWORD 1
verde DWORD 2
vermelho DWORD 0Ch
amarelo DWORD 0Eh
branco DWORD 0Fh

; Teclado
cimaDX WORD 0026h
baixoDX WORD 0028h
enterDX WORD 000Dh

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


.code

; Imprime uma linha de blocos coloridos
; Usa: ECX, EDX, EAX
LinhaBlocos PROC
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


; Imprime o logo do jogo
; Usa: EDX
PrintLogo PROC
	push edx
	
    mov edx, OFFSET centralizarHorizontal
    call WriteString
    mov edx, OFFSET logo
    call WriteString
	
	pop edx
	
    ret
PrintLogo ENDP


; Imprime a tela inicial do jogo
; Usa: EDX, EAX
TelaInicial PROC
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


; Desenha primeira parte da tela de menu
PrintBlocosMenu PROC
	call Clrscr
	
	call LinhaBlocos
	call Crlf
	call LinhaBlocos
	
	call Crlf
	call Crlf
	mov edx, OFFSET menuTitulo
	call WriteString
	
	ret
PrintBlocosMenu ENDP


; Imprime a tela de menu
; Usa: EAX, EBX, EDX
TelaMenu PROC
	push eax
	push ebx
	push edx
	
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
	je TelaMenuLeuCima
	
	cmp dx, baixoDX
	je TelaMenuLeuBaixo
	
	cmp dx, enterDX
	jne TelaMenuLeTecla
	jmp TelaMenuFim

TelaMenuLeuCima:
	jmp TelaMenuJogar

TelaMenuLeuBaixo:
	jmp TelaMenuInstru

TelaMenuFim:
	
	mov eax, ebx
	call WriteInt
	
	pop edx
	pop ebx
	pop eax
	
	ret
TelaMenu ENDP
	

main PROC
	call TelaInicial
	call TelaMenu
	exit
main ENDP
END main