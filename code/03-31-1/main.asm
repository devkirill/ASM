
	.model	tiny
	.code
	org	100h
@main:
	jmp	@start

	mes	db 'wrong mode$'
	mes2	db 'wrong page$'
	w_mode	db ?
	w_page	db ?
	w_blink	db ?
	sizeX	db ?
	sizeY	db ?
	sx	db ?
	sy	db ?
	color	db ?
	char	db 0

args:
	pushf
	push	bp
	mov	bp, sp
	push	ax bx cx dx si di

	mov	si, 0080h
	mov	di, si
	mov	bx, 0000h
	mov	bl, ds:di
	add	di, bx

	cmp	bx, 0
	je	@args5 
	mov	cx, [bp + 6]
@args1:
	inc	si
	mov	ch, ds:si
	cmp	ch, 20h
	jne	@args4 

	inc	si
	mov	ch, ds:si
	cmp	ch, 'a'
	jb	@args2 
	cmp	ch, 'z'
	ja	@args2 
	sub	ch, 20h 
@args2:
	cmp	ch, cl
	jne	@args4 

	xor	ax, ax
	mov	[bp + 8], ax
@args3:
	inc	si
	xor	dx, dx
	mov	dl, ds:si
	cmp	dl, '0'
	jb	@args4
	cmp	dl, '9'
	ja	@args4
	sub	dl, '0'
	push	dx
	mov	dx, 10
	mul	dx
	pop	dx
	add	ax, dx
	mov	[bp + 8], ax
	jmp	@args3
@args4:
	cmp	si, di
	jb	@args1 
@args5:
	pop	di si dx cx bx ax bp
	popf
	ret	2
exit:
	mov	ax, 4C00h
	int	21h
printchar:

	pushf
	push	bp
	mov	bp, sp
	push	ax bx cx dx es

	xor	bx, bx
	mov	bx, 0000h
	mov	es, bx
	mov	bx, es:44Eh
	shr	bx, 4
	add	bx, 0B800h
	mov	es, bx

	xor	ax, ax
	mov	al, [bp + 9]
	mov	bl, sizeX
	mul	bl
	xor	bx, bx
	mov	bl, [bp + 8]
	add	ax, bx
	mov	bx, 2
	mul	bx
	mov	di, ax 

	mov	al, [bp + 7]
	mov	es:[di], al
	inc	di
	mov	al, [bp + 6]
	mov	es:[di], al

	pop	es dx cx bx ax bp
	popf
	ret	2
printline:
	pushf
	push	bp
	mov	bp, sp
	push	ax bx cx dx

	mov	dx, 00h
	mov	ah, sy
	mov	al, sx
	push	ax
@printline1:
	cmp	dx, 1Fh
	je	@printline2

	mov	ax, dx
	and	ax, 1
	cmp	ax, 0
	je	@printline3
	mov	bx, 0040h 
	jmp	@printline4
@printline3:
	mov	bh, char
	inc	char
	mov	bl, 46h
@printline4:
	push	bx

	call	printchar

	pop	ax
	inc	ax 
	inc	dx 
	push	ax
	jmp	@printline1

@printline2:
	pop	ax dx cx bx ax bp
	popf
	ret

printfirstline:
	pushf
	push	bp
	mov	bp, sp
	push	ax bx cx dx

	mov	dx, 0
	mov	ah, sy
	mov	al, sx
	push	ax
@printfirstline1:
	cmp	dx, 1Fh
	je	@printfirstline2

	mov	ax, dx
	and	ax, 1
	cmp	ax, 0
	je	@printfirstline3
	mov	bx, 0040h 
	jmp	@printfirstline4
@printfirstline3:
	mov	bx, dx
	shl	bx, 7
	mov	bh, char
	inc	char
	mov	bl, 40h 

	mov	ax, dx
	and	ax, 2
	cmp	ax, 0
	je	@printfirstline4
	cmp	w_blink, 0
	jne	@printfirstline4
	add	bl, 80h 
@printfirstline4:
	push	bx

	call	printchar

	pop	ax
	inc	ax 
	inc	dx 
	push	ax
	jmp	@printfirstline1

@printfirstline2:
	pop	ax dx cx bx ax bp
	popf
	ret

printsecondline:
	pushf
	push	bp
	mov	bp, sp
	push	ax bx cx dx

	mov	dx, 00h
	mov	ah, sy
	mov	al, sx
	push	ax
@printsecondline1:
	cmp	dx, 1Fh
	je	@printsecondline2

	mov	ax, dx
	and	ax, 1
	cmp	ax, 0
	je	@printsecondline3
	mov	bx, 0040h 
	jmp	@printsecondline4
@printsecondline3:
	mov	bx, dx
	shr	bx, 1
	mov	bh, char
	inc	char
	and	bl, 7
	add	bl, 8
	add	bl, 40h
@printsecondline4:
	push	bx

	call	printchar

	pop	ax
	inc	ax 
	inc	dx 
	push	ax
	jmp	@printsecondline1

@printsecondline2:
	pop	ax dx cx bx ax bp
	popf
	ret

printtable:
	push	bp
	mov	bp, sp

	xor	ah, ah
	mov	al, sizeX
	mov	bx, 1Fh
	sub	ax, bx
	mov	bl, 02h
	div	bl
	mov	sx, al

	xor	ah, ah
	mov	al, sizeY
	mov	bx, 10h
	sub	ax, bx
	mov	bl, 02h
	div	bl
	mov	sy, al

	mov	char, 0

	call	printmodepage
 
	call	printfirstline
	inc	sy
	call	printsecondline
	inc	sy
	call	printline
	inc	sy
	call	printline
	inc	sy

	call	printline
	inc	sy
	call	printline
	inc	sy
	call	printline
	inc	sy
	call	printline
	inc	sy

	call	printline
	inc	sy
	call	printline
	inc	sy
	call	printline
	inc	sy
	call	printline
	inc	sy

	call	printline
	inc	sy
	call	printline
	inc	sy
	call	printline
	inc	sy
	call	printline

	mov	sp, bp
	pop	bp
	ret

printmodepage:
	pushf
	push	bp
	mov	bp, sp
	push	ax bx

	dec	sy

	mov	ah, sy
	mov	al, sx
	add	ax, 5

	mov	bh, 'M'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, 'O'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, 'D'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, 'E'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, ' '
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, '='
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, ' '
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, w_mode
	add	bh, '0'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	add	ax, 5 

	mov	bh, 'P'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, 'A'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, 'G'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, 'E'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, ' '
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, '='
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, ' '
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	mov	bh, w_page
	add	bh, '0'
	mov	bl, 07h
	push	ax
	push	bx
	call	printchar
	pop	ax
	inc	ax

	add	sy, 2

	pop	bx ax bp
	popf
	ret

checkmode:
	pushf
	push	ax
	mov	al, w_mode
 
	cmp	al, 03
	jbe	@checkmode1
	cmp	al, 07
	je	@checkmode1

	mov	ah, 09h
	lea	dx, mes
	int	21h
	jmp	exit
@checkmode1:
	pop	ax
	popf
	ret

checkpage:
	pushf
	push	ax
	mov	ah, w_mode
	mov	al, w_page
 
	cmp	al, 0
	je	@checkpage1
	cmp	ah, 07
	je	@checkpage2
	cmp	al, 07
	jbe	@checkpage1
@checkpage2:
	mov	ah, 09h
	lea	dx, mes
	int	21h
	jmp	exit
@checkpage1:
	pop	ax
	popf
	ret

@start:
	push	0
	push	'M'
	call	args
	pop	ax
	mov	w_mode, al

	push	0
	push	'P'
	call	args
	pop	ax
	mov	w_page, al

	push	1
	push	'B'
	call	args
	pop	ax
	mov	w_blink, al

	call	checkmode
	call	checkpage

	mov	ah, 00h
	mov	al, w_mode
	int	10h 

	mov	ah, 05h
	mov	al, w_page
	int	10h 

	mov	ah, 0Fh
	int	10h 
	mov	sizeX, ah
	mov	sizeY, 25

	call	printtable

	mov	ah, 00h
	int	16h 

	jmp	exit
end @main
