        .model tiny
        .code
        extrn print: far
        extrn args: far
        org 100h
@main:
        jmp @start

        mes2    db 'we have interrupt$'
        mes     db 'smth$'
        dot2    db ':$'
        segm    dw 0h
        ip      dw 0h

@printtable:
        push    bp
        mov     bp, sp
        mov     ah, 0Fh
        int     10h

        mov     al, ah
        xor     ah, ah
        mov     bx, 1Fh
        sub     ax, bx
        mov     bl, 02h
        div     bl
        mov     ah, 04h
        push    ax


        ;mov     al, 00h
        ;mov     dl, 10h

        push    004Eh 0000h
        call    @printline

        mov     [bp - 4], 004Ah
        call    @printline

        mov     [bp - 4], 004Fh
        call    @printline

        mov     [bp - 4], 004Dh
        call    @printline


        mov     [bp - 4], 0029h
        call    @printline

        mov     [bp - 4], 002Bh
        call    @printline

        mov     [bp - 4], 002Ch
        call    @printline

        mov     [bp - 4], 0028h
        call    @printline


        mov     [bp - 4], 0097h
        call    @printline

        mov     [bp - 4], 0096h
        call    @printline

        mov     [bp - 4], 0094h
        call    @printline

        mov     [bp - 4], 0013h
        call    @printline


        mov     [bp - 4], 0072h
        call    @printline

        mov     [bp - 4], 0071h
        call    @printline

        mov     [bp - 4], 00F0h
        call    @printline

        mov     [bp - 4], 0075h
        call    @printline

        mov     sp, bp
        pop     bp
        ret

@printline:
        pushf
        push    bp
        mov     bp, sp
        push    ax bx cx dx

        mov     ax, [bp + 6]
        mov     dx, [bp + 10]
        mov     si, 0000h
        mov     di, 0010h
@printline_1:
        cmp     si, di
        je      @printline_2
        inc     si

        mov     ah, 02h
        mov     bh, 00h
        int     10h
        inc     dl

        push    ax
        mov     ax, 0001h
        cmp     ax, si
        je      @printline_3
        mov     ax, 0900h
        mov     bx, 0040h
        mov     cx, 0001h
        int     10h
        mov     ah, 02h
        mov     bh, 00h
        int     10h
        inc     dl
@printline_3:
        pop     ax

        mov     ah, 09h
        mov     bx, [bp + 8]
        mov     cx, 0001h
        int     10h
        inc     al

        jmp     @printline_1
@printline_2:
        add     [bp + 6], 10h
        add     [bp + 10], 100h
        pop     dx cx bx ax bp
        popf
        ret

@start:
        push    0
        push    'M'
        call    args
        pop     ax
        mov     ah, 00h
        int     10h

        push    0
        push    'P'
        call    args
        pop     ax
        mov     ah, 05h
        int     10h

        call    @printtable

        mov     ah, 00h
        int     16h

        jmp     @exit

        mov     ax, 123
        push    ax
        call    print

        mov     ax, 0955h
        mov     bx, 0005h
        mov     cx, 80          ; кол-во выводимых символов
        int     10h


        mov     ah, 00h
        int     16h

@exit:
        mov     ax,4C00h
        int     21h
end @main
