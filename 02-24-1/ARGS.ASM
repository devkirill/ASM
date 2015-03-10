        .model tiny
        .code
        public args
args:
        pushf
        push    bp
        mov     bp, sp
        push    ax bx cx dx si di

        mov     si, 0080h
        mov     di, si
        mov     bx, 0000h
        mov     bl, ds:di
        add     di, bx

        cmp     bx, 0
        je      @@5                     ; bx == 0
        mov     cx, [bp + 8]
@@1:
        inc     si
        mov     ch, ds:si
        cmp     ch, 20h
        jne     @@4                     ; ch != 20h

        inc     si
        mov     ch, ds:si
        cmp     ch, 'a'
        jb      @@2                     ; ch < 'a'
        cmp     ch, 'z'
        ja      @@2                     ; ch > 'z'
        sub     ch, 20h                 ; 'a' -> 'A'
@@2:
        cmp     ch, cl
        jne     @@4                     ; ch != cl

        xor     ax, ax
        mov     [bp + 10], ax
@@3:
        inc     si
        xor     dx, dx
        mov     dl, ds:si
        cmp     dl, '0'
        jb      @@4
        cmp     dl, '9'
        ja      @@4
        sub     dl, '0'
        push    dx
        mov     dx, 10
        mul     dx
        pop     dx
        add     ax, dx
        mov     [bp + 10], ax
        jmp     @@3
@@4:
        cmp     si, di
        jb      @@1                     ; si < di
@@5:
        pop     di si dx cx bx ax bp
        popf
        ret     4
end args