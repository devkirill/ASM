
	.model	tiny
	.code
	org	100h
@main:
	jmp	@start
exit:
	mov	ax, 4C00h
	int	21h

mes db 8
len db ?
chars db 0, 0, 0, 0, 0, 0, 0
return db 0

@start:
        mov AH, 0Ah
        mov DX, CS
        mov DS, DX
        lea DX, mes
        int 21h

        mov ah, 02h
        mov dl, 10
        int 21h

        lea DX, chars
        mov bl, len
        add dx, bx
        mov di, dx
        lea dx, chars
        mov byte ptr [cs:di], '$'
        mov AH, 09H
        int 21h

	jmp	exit
end @main
