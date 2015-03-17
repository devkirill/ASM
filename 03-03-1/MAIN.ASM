.model tiny ;data model
.code
.386
org 100h
@entry:
		jmp @start
		mes2 db 'we have interrupt$'
		mes db 'smth$'
		dot2 db ':$'
		segm dw 0h
		ip dw 0h
		
@printMsg:
		mov ah, 09h
		lea dx, mes2
		int 21h
		ret
		
@start:
		mov ah, 0c7h;
		int 2Fh;
		cmp dx, 1324
		je @printMsg
		mov ah, 35h; получить вектор обработчика 2f
		mov al, 2fh
		int 21h
		mov ip, bx
		mov segm, es
		
		mov ah,25h
		mov al, 2fh ; установить вектор прерывания 2F
		lea dx, message
		int 21h
		
		
		lea ax, segm
		call printHexNumber
		mov ah, 09h
		lea dx, dot2
		int 21h
		lea ax, ip
		call printHexNumber
		mov ah, 02h
		mov dl, 0ah
		int 21h
		mov ax, cs
		call printHexNumber
		mov ah, 09h
		lea dx, dot2
		int 21h
		lea ax, message
		call printHexNumber
		mov ah, 02h
		mov dl, 0ah
		int 21h
		
		
		mov ah, 31h
		xor al, al
		mov dx, 0FFh
		int 21h
		
		
message proc
		cmp ah, 0c7h
		je @weHave
		push ax	bx cx dx ; нужно сделать ds = cs, пото обратно
		mov ah, 09h
		
		push ds cs
		pop ds
		
		lea dx, mes
		int 21h	
		pop ds dx cx bx ax
		push cs:segm ; segment
		push cs:ip     ; offset
		retf

@weHave:
		mov dx, 1324
		iret
		
message endp

printHexNumber proc
        push bx cx dx
        mov bx, ax
        mov cx, 4
@k:		rol bx, 4
        mov al, bl
        and al, 0fh
        cmp al, 10
        sbb al, 69h
        das
        mov dh, 02h
        xchg ax, dx
        int 21h
        loop @k
        pop dx cx bx
        ret
printHexNumber endp

		
end @entry
