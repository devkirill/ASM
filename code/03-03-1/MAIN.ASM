.model tiny ;data model
.code
org 100h
@main:
        jmp     @load
        mes2    db 'WE HAVE INTERRUPT ', 0Ah, 0Dh, '$'
        mes     db 'TSR $'
        dot2    db ':$'
        segm    dw 0h
        ip      dw 0h

message proc
        cmp     ah, 0C7h
        je      @weHave
        push    ax bx cx dx ; нужно сделать ds = cs, пото обратно
        mov     ah, 09h
        
        push    ds cs
        pop     ds
        
        lea     dx, mes
        int     21h     
        pop     ds dx cx bx ax
        push    cs:segm ; segment
        push    cs:ip   ; offset
        retf

@weHave:
        mov     dx, 1324
        iret

@end_tsr:

@printMsg:
        mov     ah, 09h
        lea     dx, mes2
        int     21h
        jmp     @next

@load:
        mov     ah, 0C7h
        int     2Fh
        cmp     dx, 1324
        je      @printMsg
@next:
        mov     ah, 35h; получить вектор обработчика 2f
        mov     al, 2fh
        int     21h
        mov     ip, bx
        mov     segm, es

        lea     ax, segm
        call    printHexNumber
        mov     ah, 09h
        lea     dx, dot2
        int     21h
        lea     ax, ip
        call    printHexNumber
        mov     ah, 02h
        mov     dl, 0Ah
        int     21h
        mov     dl, 0Dh
        int     21h

        mov     ah, 25h
        mov     al, 2fh ; установить вектор прерывания 2F
        lea     dx, message
        int     21h
        
        mov     ax, cs
        call    printHexNumber
        mov     ah, 09h
        lea     dx, dot2
        int     21h
        lea     ax, message
        call    printHexNumber
        mov     ah, 02h
        mov     dl, 0Ah
        int     21h
        mov     dl, 0Dh
        int     21h
    
        mov     ax, 3100h
        mov     dx, (@end_tsr - @main + 10Fh) / 16
        int     21h

@exit:
        mov     ax,4C00h
        int     21h

message endp

printHexNumber proc
        push    bx cx dx
        mov     bx, ax
        mov     cx, 4
@k:
        rol     bx, 4
        mov     al, bl
        and     al, 0Fh
        cmp     al, 10
        sbb     al, 69h
        das
        mov     dh, 02h
        xchg    ax, dx
        int     21h
        loop    @k
        pop     dx cx bx
        ret
printHexNumber endp

end @main
