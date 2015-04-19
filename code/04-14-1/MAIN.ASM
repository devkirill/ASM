	.model	tiny
	.code
	org	100h
@main:
	jmp	@start

help db 'SCAN', 9, 'ASCII', 9, 'CHAR', 13, 10, '$'
separator db 9, '$'
separator2 db 13, '$'

exit:
	mov	ax, 4C00h
	int	21h
print:
	push	bp
	mov	bp, sp
	push	ax bx cx dx
	push	-1
	mov	ax, [bp + 4]
	mov	cx, 10
@print1:
	xor	dx, dx
	div	cx
	push	dx
	cmp	ax, 0
	jne	@print1
	mov	ah, 02h
@print2:
	pop	dx
	cmp	dx, -1
	je	@print3
	add	dl, '0'
	int	21h
	jmp	@print2
@print3:

	pop	dx cx bx ax bp
	ret	2

printchar:
	push	bp
	mov	bp, sp
	push	ax bx cx dx es

	mov	ah, 0Fh
	int	10h

	mov	ah, 09h
	mov	cx, 1
	mov	al, [bp + 4]
	mov	bl, [bp + 5]
	int	10h

	mov	ah, 03h
	int	10h

	mov	ah, 02h
	inc	dh
	int	10h

	pop	es dx cx bx ax bp
	ret	2

@start:
	mov	DX, CS
	mov	DS, DX

	lea	DX, help
	mov	AH, 09h
	int	21h

mainwhile:
	mov	AH, 00h
	int	16h

	cmp	al, 1Bh
	je	exit

	mov	bh, 07h
	mov	bl, al
	push	bx

	xor	bh, bh
	push	bx

	mov	bl, ah
	push	bx

	mov	AH, 09h
	lea	DX, separator
	call	print
	int	21h

	call	print
	int	21h

	call	printchar
	lea	DX, separator2
	int	21h

	jmp	mainwhile
end @main
