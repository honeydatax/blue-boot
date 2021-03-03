org 0x100
call area
loop1:
mov ax,cs
mov ds,ax
mov ah,9
mov dx,label
int 240
mov ah,1
int 240
jmp loop1
call halts
print:
mov bx,dx
print1:
ds
mov dl,[bx]
cmp dl,'$'
jz print2
cmp dl,0
jz print2
mov ah,2
int 240
inc bx
jmp print1
print2:
jmp irets
printchr:
mov al,dl
mov ah,0eh
mov bl,7
mov bh,0
int 10h
jmp irets
inputx:
mov ax,0
int 16h
mov dl,al
mov ah,2
int 240
jmp irets
inputs:
mov ah,1
int 240
jmp irets
halts:
jmp halts
area:
vectors:
mov ax,0
mov ds,ax
mov ax,vectorsi
mov dx,cs
mov di,960
	vectors1:
	ds
	mov [di],ax
	add di,2
	ds
	mov [di],dx
	add di,2
mov ax,0
mov ds,ax
mov ax,vectorsi
mov dx,cs
mov di,132
	vectors2:
	ds
	mov [di],ax
	add di,2
	ds
	mov [di],dx
	add di,2
mov ax,cs
mov ds,ax
mov ax,cs
mov ds,ax
ret
vectorsi:
push si
push di
push ds
push es
push ax
push bx
push cx
push dx
push bp
crts1:
cmp ah,1
jnz crts2
jmp inputx
crts2:
cmp ah,2
jnz crts3
jmp printchr
crts3:
crts9:
cmp ah,9
jnz crts3
jmp print
crts10:
irets:
pop bp
pop dx
pop cx
pop bx
pop ax
pop es
pop ds
pop di
pop si
iret
label db 13,10,'kernel version 0.01v',13,10,'$' ,0
