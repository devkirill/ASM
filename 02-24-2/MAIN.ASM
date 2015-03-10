        .model tiny
        .code
        org 100h
@entry:
        jmp 	@start

        mes db 'TSR $'
        jcs dw 0h
        jip dw 0h
@start:
        mov 	ax, 352Fh
        int 	21h
        mov 	jip, bx
        mov 	jcs, es

        mov     ax, 252Fh
        lea 	dx, tsr
        int 	21h

        mov 	ax, 3100h
        mov 	dx, 00FFh
        int 	21h

tsr proc
        push 	ax bx cx dx ds
        push 	cs
        pop 	ds

        mov 	ah, 09h
        lea 	dx, mes
        int 	21h

        pop 	ds dx cx bx ax
        push 	cs:jcs
        push 	cs:jip
        retf
tsr endp

end @entry