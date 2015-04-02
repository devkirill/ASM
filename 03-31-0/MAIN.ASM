        .model tiny
        .code
        org 100h
@main:
        mov     dx, 0000h
        mov     si, 0030h

@a:
        mov     ah, 02h
        cmp     dx, si
        je      @exit
        int     21h

        ;mov     ah, 00h
        ;int     16h

        inc     dx
        jmp     @a

@exit:
        mov     ax,4C00h
        int     21h
end @main
