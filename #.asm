org 0x100
call area
loop1:
mov ax,cs
mov ds,ax
mov ah,9
mov dx,label
int 240
mov ax,cs
mov ds,ax
mov ah,0ah
mov dx,labeli
int 240
mov ax,cs
mov ds,ax
mov ah,9
mov dx,labelii
int 240
mov ax,cs
mov ds,ax
mov ah,9
mov dx,labeliii
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
push cx
jmp irets2
inputs:
mov ah,1
int 240
jmp irets
kinput:
mov si,dx
ds
mov cl,[si]
inc si
inc si
mov ch,0
mov di,si
kinput2:
mov ah,0
int 16h
cmp al,8
jnz kinput3
cmp ch,0
jz kinput2
dec ch
dec di
push cx
mov ah,3
mov bh,0
int 10h
cmp dl,0
jnz kinput4
mov dl,79
dec dh
kinput4:
dec dl
mov bh,0
mov ah,2
int 10h
mov ah,0ah
mov al,32
mov cx,2
mov bl,7
mov bh,0
int 10h
pop cx
jmp kinput2
kinput3:
cmp al,13
jz kinput8
cmp cl,ch
jz kinput2
ds
mov [di],al
inc di
inc ch
mov dl,al
mov ah,2
int 240
jmp kinput2
kinput8:
dec si
ds
mov [si],ch
jmp irets
gver:
mov al,5
mov ah,0
mov bh,0
mov cx,0
pop dx
pop dx
pop dx
jmp irets10
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
ret
vectorsi:
push bp
push si
push di
push ds
push es
push dx
push bx
push cx
push ax
crts0:
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
jnz crts10
jmp print
crts10:
cmp ah,0ah
jnz crts11
jmp kinput
crts11:
crts30h:
cmp ah,030h
jnz crts31h
jmp gver
crts31h:

irets:
pop ax
irets2:
pop cx
pop bx
irets10:
pop dx
pop es
pop ds
pop di
pop si
pop bp
iret
label db 13,10,'kernel version 0.02v',13,10,'$' ,0
labelii db 13,10,"$",0
labeli db 9,0
labeliii db '          ',13,10,'$' ,0
labeliiii db "  $",0
