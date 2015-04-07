	.model	tiny
	.code
	extrn	print: far
	extrn	args: far
	org	100h
@main:
	jmp	@start

	mes	db 'wrong mode$'
	mes2	db 'wrong page$'
	w_mode	db ?
	w_page	db ?
	sizeX	db ?
	sizeY	db ?

@printtable:
	push	bp
	mov	bp, sp
	mov	ah, 0Fh
	int	10h

	mov	al, ah
	xor	ah, ah
	mov	bx, 1Fh
	sub	ax, bx
	mov	bl, 02h
	div	bl
	mov	ah, 04h
	push	ax

	mov	cl, 4Eh
	push	cx 0000h
	call	@printline

	mov	byte ptr [bp - 4], 4Ah
	call	@printline

	mov	byte ptr [bp - 4], 4Fh
	call	@printline

	mov	byte ptr [bp - 4], 4Dh
	call	@printline

	mov	byte ptr [bp - 4], 29h
	call	@printline

	mov	byte ptr [bp - 4], 2Bh
	call	@printline

	mov	byte ptr [bp - 4], 2Ch
	call	@printline

	mov	byte ptr [bp - 4], 28h
	call	@printline

	mov	byte ptr [bp - 4], 97h
	call	@printline

	mov	byte ptr [bp - 4], 96h
	call	@printline

	mov	byte ptr [bp - 4], 94h
	call	@printline

	mov	byte ptr [bp - 4], 13h
	call	@printline

	mov	byte ptr [bp - 4], 72h
	call	@printline

	mov	byte ptr [bp - 4], 71h
	call	@printline

	mov	byte ptr [bp - 4], (80h + 70h)
	call	@printline

	mov	byte ptr [bp - 4], 75h
	call	@printline

	mov	ah, 02h
	mov	bh, ch
	mov	dx, 2400h
	int	10h

	mov	sp, bp
	pop	bp
	ret

@printline:
	pushf
	push	bp
	mov	bp, sp
	push	ax bx cx dx

	mov	ax, [bp + 6]
	mov	dx, [bp + 10]
	mov	si, 0000h
	mov	di, 0010h
@printline_1:
	cmp	si, di
	je	@printline_2
	inc	si

	mov	ah, 02h
	mov	bh, ch
	int	10h
	inc	dl

	push	ax
	mov	ax, 0001h
	cmp	ax, si
	je	@printline_3
	mov	ax, 0900h
	mov	bx, 0040h
	mov	bh, ch
	push	cx
	mov	cx, 0001h
	int	10h
	pop	cx
	mov	ah, 02h
	mov	bh, ch
	int	10h
	inc	dl
@printline_3:
	pop	ax

	mov	ah, 09h
	mov	bx, [bp + 8]
	push	cx
	mov	cx, 0001h
	int	10h
	pop	cx
	inc	al

	jmp	@printline_1
@printline_2:
	add	word ptr [bp + 6], 0010h
	add	word ptr [bp + 10], 0100h
	pop	dx cx bx ax bp
	popf
	ret
@checkmode:
	mov	bp, sp
	mov	ax, [bp+2]
	mov	bx, 04h
	cmp	ax, bx
	jb	@checkmode_1
	mov	bx, 07h
	cmp	ax, bx
	je	@checkmode_1

	mov	ah, 09h
	lea	dx, mes
	int	21h
	jmp	@exit

@checkmode_1:
	mov	sp, bp
	ret

@checkpage:
	mov	bp, sp
	mov	ax, [bp+2]
	mov	bx, 08h
	cmp	ax, bx
	jb	@checkpage_1

	mov	ah, 09h
	lea	dx, mes2
	int	21h
	jmp	@exit

@checkpage_1:
	mov	sp, bp
	ret

@start:
	push	0
	push	'M'
	call	args
	call	@checkmode
	pop	ax
	mov	ah, 00h
	int	10h

	push	0
	push	'P'
	call	args
	call	@checkpage
	pop	ax
	mov	ch, al
	mov	ah, 05h
	int	10h

	call	@printtable

	mov	ah, 00h
	int	16h

	jmp	@exit

	mov	ax, 123
	push	ax
	call	print

	mov	ax, 0955h
	mov	bx, 0005h
	mov	cx, 80 
	int	10h

	mov	ah, 00h
	int	16h

@exit:
	mov	ax,4C00h
	int	21h
end @main
