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

;Teclado
cimaDX WORD 0026h
baixoDX WORD 0028h
enterDX WORD 000Dh

;Tela inicial
bloco BYTE 0DBh, 0DBh, 0DBh, 0DBh, 0
logo BYTE "  ________              .__              ", 0Dh, 0Ah, 5 DUP (9),
		  " /  _____/  ____   ____ |__|__ __  ______ ", 0Dh, 0Ah, 5 DUP (9),
		  "/   \  ____/ __ \ /    \|  |  |  \/  ___/", 0Dh, 0Ah, 5 DUP (9),
		  "\    \_\  \  ___/|   |  \  |  |  /\___ \ ", 0Dh, 0Ah, 5 DUP (9),
		  " \______  /\___  >___|  /__|____//____  >", 0Dh, 0Ah, 5 DUP (9),
		  "        \/     \/     \/              \/ ", 0Dh, 0Ah, 0

creditos BYTE "    Criado por:", 0Dh, 0Ah,
			   "    Marcio Lima Inacio", 0Dh, 0Ah,
			   "    Samara Assis", 0Dh, 0Ah,

;Tela de menu
menuTitulo BYTE "    MENU", 3 DUP (0Dh, 0Ah), 0
menu1 BYTE "    1. Jogar", 2 DUP (0Dh, 0Ah), 0
menu2 BYTE "    2. Instrucoes", 2 DUP (0Dh, 0Ah), 0

.code

;Imprime uma linha de blocos coloridos
;Usa: ECX, EDX, EAX
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

;Imprime o logo do jogo
;Usa: EDX
Logo PROC
	push edx
	
    mov edx, OFFSET centralizarHorizontal
    call WriteString
    mov edx, OFFSET logo
    call WriteString
	
	pop edx
	
    ret
Logo ENDP

;Imprime a tela inicial do jogo
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
	
	call Logo
	
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

;Imprime a tela de menu
;Usa: EDX
TelaMenu PROC
	push eax
	push edx
	
	call Clrscr
	
	call LinhaBlocos
	call Crlf
	call LinhaBlocos
	
	call Crlf
	call Crlf
	mov edx, OFFSET menuTitulo
	call WriteString
	mov edx, OFFSET menu1
	call WriteString
	mov edx, OFFSET menu2
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
	mov eax, 10
	call WriteInt
	jmp TelaMenuLeTecla

TelaMenuLeuBaixo:
	mov eax, 20
	call WriteInt
	jmp TelaMenuLeTecla

TelaMenuFim:
	
	pop edx
	pop eax
	
	ret
TelaMenu ENDP
	

main PROC
	call TelaInicial
	call TelaMenu
	exit
main ENDP
END main