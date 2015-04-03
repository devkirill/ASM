        .model tiny
        .code
        extrn print: far
        extrn args: far
        org 100h
main:
        push cs
        pop ds

;code    segment
;        assume  cs:code, ds:code
;        extrn print: far
;        ;extrn args: far
;        org     100h
;main:f 
        jmp     load
        mes     db 'TSR $'
tsr:
        push    ax bx cx dx ds
        push    cs
        pop     ds

        mov     ah, 09h
        mov     dx, offset mes
        int     21h

        db      9Ah                     ; call far
        jip     dw 0000h
        jcs     dw 0000h

        pop     ds dx cx bx ax
        ret
end_tsr:

load:
        mov     ax,  352Fh
        int     21h
        mov     jip, bx
        mov     jcs, es

        mov     ax,  252Fh
        mov     dx,  offset tsr
        int     21h

        push    0
        push    'I'
        call    args
        pop     ax

        cmp     ax, 21
        je      @@21
        cmp     ax, 27
        je      @@27
        jmp     exit

@@21:
        mov     ax, 3100h
        mov     dx, (end_tsr - main + 10Fh) / 16
        int     21h
        jmp     exit
@@27:
        mov     dx, end_tsr - main + 1
        int     27h
        jmp     exit
exit:
        mov     ax,4C00h
        int     21h
        end     main
