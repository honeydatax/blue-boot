org 0x7c00
;-------------------------------------------------------
;boot blue
;jump disk table
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
;--------------------------------------------------------
;calcalation of root directory sector this sector + sfat X tfat 
eess            dw      0
;calculation strack X HEADS
ees1            dw      0
nop
ees:
;--------------------------------------------------------
;calculation strack X HEADS		
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
;--------------------------------------------------------		
;calcalation of root directory sector this sector + sfat X tfat 
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
;load root directory
call func
;--------------------------------------------------------
mov bp,100h
;find #.COM in the root directory
;loop finde char 35
mloop:
	es
	mov al,[bp]
	cmp al,35
	jz mloop1
	add bp,32
	cmp bp,300h
jb mloop  
;if not find #.com jump to halt 
jmp halts
mloop1:
;--------------------------------------------------------
;retrive sector number of root directory table
    add bp,1ah
    es
    mov ax,[bp]
;add root dir + sector number of file
	cs
	mov bx,[eess]
    add ax,bx
    add ax,29
 ;load #.COM kernel into address 1000h:100h
call func
;--------------------------------------------------------
;clear int vector 20h
call vectors
;put 1000h:100h in stack to jump to 1000h:100h
	mov ax,1000h
	mov es,ax
	mov ds,ax
	mov ax,0x1000
	push ax
	mov ax,0x100
	push ax
;start ax bx cx dx to enter on program
	mov ax,0
	mov bx,0
	mov cx,0x8000
	mov dx,0
	mov si,0
	mov di,0
;jump to 1000h:100h
retf
;--------------------------------------------------------
;if it fail reboot
       mov ax,202
int 19h
        ret
;--------------------------------------------------------
;function to load sectores and directory root to memory
func:
;ipush
        push bp
        push dx
        push cx
        push bx
        push ax
        
        xor dx,dx
        xor cx,cx
        cs
;calculation sectorer 
        mov bx,[ees1]
        clc
        idiv bx
        push ax
        mov ax,dx

        xor dx,dx
        xor cx,cx
        cs
;calculation sectorer
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
        
        
        
;load into 1000h:100h
        mov ax,1000h
        mov bx,100h
        mov es,ax
        mov al,30
        mov ah,2
        mov dl,0
;int load sectores into memory
int 13h
;ipop        

        pop ax
        pop bx
        pop cx
        pop dx
        pop bp
        ret
;--------------------------------------------------------
;define int 20h and 21h to reset iret
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
;--------------------------------------------------------
;clear iret call
vectorsi:
iret
ret
;--------------------------------------------------------
;debug print function
printe:
;clear screen
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
	mov cx,1536
	mov al,1
	mov ah,13h
int 10h
;--------------------------------------------------------
;if #.COM not find enter in halt mode to turn pc
halts:
jmp halts
