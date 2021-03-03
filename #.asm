org 0x100
call screen
mov bp,label
mov cx,16
call printe
call halts
screen:
mov ax,3
int 10h
ret
printe:
mov ax,cs
mov es,ax
mov bh,0
mov bl,1
mov dl,1
mov dh,1
mov al,1
mov ah,13h
int 10h
ret
halts:
jmp halts
label db 'hello world' , 13,10