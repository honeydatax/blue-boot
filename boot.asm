org 0x7c00
jmp ees
nop
oem             db      'MY OEM  '
bsector         dw      200h
scluster        db      1h 
rsector         dw      1h
tfat            db      2h
rent            dw      0e0h
tsectors        dw      0b40h
media           db      0f0h 
sfat            dw      9h
strak           dw      12h
head            dw      2h
hidden          dd      0h
large           dd      0h
drive           db      0h
flag            db      0h
sig             db      29h
vol             dd      0ffffffffh
label           db      'MY LABEL    '
id              db      'FAT12   '
eess            dw      0
ees1            dw      0
nop
ees:		
		cs
		mov ax,[strak]
		cs
		mov bx,[head]
		mov cx,0
		mov dx,0
		clc
		mul bx
		cs
		mov [ees1],ax
		mov ax,0
		cs
		mov bx,[sfat]
		cs
		mov al,[tfat]
		mov dx,0
		mov cx,0
		clc
		mul bx
		cs
		mov bx,[hidden]
		clc
		add ax,bx
		inc ax
		mov bx,ax
		cs
		mov [eess],ax
        mov ax,1000h
        mov es,ax
        mov ax,bx

call func
jmp printe

mov bp,100h

mloop:
es
mov al,[bp]
cmp al,35
jz mloop1
add bp,32
cmp bp,300h
jb mloop  
jmp myloop

mloop1:
        add bp,1ah
        es
        mov ax,[bp]
        add ax,31
call func

call vectors

mov ax,1000h
mov es,ax
mov ds,ax
mov ax,0x1000
push ax
mov ax,0x100
push ax
mov ax,0
mov bx,0
mov cx,0x8000
mov dx,0
mov si,0
mov di,0
retf

myloop:
call check
cmp al,0
jnz myloop





        mov ax,202
int 19h

check:
        in al,60h
        and al,128
        ret

func:
        push bp
        push dx
        push cx
        push bx
        push ax
        
        xor dx,dx
        xor cx,cx
        cs
        mov bx,[ees1]
        clc
        idiv bx
        push ax
        mov ax,dx

        xor dx,dx
        xor cx,cx
        cs
        mov bx,[strak]
        clc
        idiv bx
        push ax
        mov ax,dx
        inc dx
        mov cl,dl
        pop ax
        mov dh,al
        pop ax
        mov ch,al
        
        
        

        mov ax,1000h
        mov bx,100h
        mov es,ax
        mov al,30
        mov ah,2
        mov dl,0

int 13h
        

        pop ax
        pop bx
        pop cx
        pop dx
        pop bp
        ret

vectors:
mov cl,64
mov ax,0
mov ds,ax
mov ax,vectorsi
mov dx,0
mov di,128
	vectors1:
	ds
	mov [di],ax
	add di,2
	ds
	mov [di],dx
	add di,2
	dec cl
	cmp cl,0
	jnz vectors1
ret
vectorsi:
iret
ret
printe:
        mov ax,3
int 10h
mov bx,label
mov al,'*'
cs
mov [bx],al
mov bp,100h
mov ax,1000h
mov es,ax
mov bh,0
mov bl,1
mov dl,1
mov dh,1
mov cx,512
mov al,1
mov ah,13h
int 10h
printe2:
jmp printe2