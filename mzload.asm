org 0x100
	call bootcopy
	call exec
;----------------------------------
;cs load
mov ax,3000h
mov ds,ax
mov bx,0x8
ds
mov cx,[bx]
add ax,cx
mov bx,0x16
ds
mov cx,[bx]
add ax,cx
mov si,ax
;----------------------------------
;ip load
mov bx,0x14
ds
mov cx,[bx]
mov di,cx
;----------------------------------
;ss load
mov ax,ds
mov sp,0xFFFF
mov bx,0x0e
ds
mov cx,[bx]
add ax,cx
mov ss,ax
;----------------------------------
;sp load
mov bx,0x10
ds
mov cx,[bx]
mov sp,cx
;----------------------------------
push si
push di
mov ax,cs
mov ds,ax
mov es,ax
mov si,0
mov di,0
mov bx,0
mov dx,0
mov cx,32000
mov ax,0
retf
loop1:
	mov ah,0
int 0x21
halt:
jmp halt
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
        
        mov ax,[addressld]
        mov bx,[address]
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
;--------------------------------------------------------
exec:
	mov ax,3000h
	cs
	mov [addressld],ax
	mov ax,0h
	cs
	mov [address],ax
	mov ax,9000h
	mov es,ax
	mov si,0h
mloop:
	cs
	mov cl,[labeli+1]
	mov di,labeliii
	mov bp,si
	mmloop:
		es
		mov al,[bp]
		cs
		mov ah,[di]
		inc bp
		inc di
		cmp al,ah
		jnz mloop10 
		dec cl
		jnz mmloop
	jmp mloop1
	mloop10:
	add si,32
	cmp si,300h
jb mloop  
;if not find com jump to main loop 
jmp loop1
mloop1:
;--------------------------------------------------------
;retrive sector number of root directory table
    add si,1ah
    es
    mov ax,[si]
	mov dx,0
	mov cx,0
	mov bx,4
	clc
	mul bx
;add root dir + sector number of file
	cs
	mov bx,[eess]
    add ax,bx
    add ax,20
    
 ;load COM file into address 2000h:100h
 push cs
 push cs
 pop ds
 pop es
call func
 push cs
 push cs
 pop ds
 pop es
ret
;--------------------------------------------------------
;--------------------------------------------------------
printe:
	mov ax,3000h
	mov es,ax
	mov ax,cs
	mov ds,ax
	mov bl,7
	mov cx,256
	mov dl,1
	mov dh,1
	mov al,1
	mov bp,0
	mov ah,0x13
int 0x10
	mov bp,sp
ret
;-----------------------------------------------------------
;copy boot
bootcopy:
	mov ax,ees
	mov bx,ddisk
	clc
	sub ax,bx
	mov cx,ax
	mov ax,0
	mov ds,ax
	mov ax,cs
	mov es,ax
	mov si,7c00h
	mov di,ddisk
call strcp
	mov ax,cs
	mov es,ax
	mov ds,ax
ret
;-----------------------------------------------------------
strcp:
strcp2:
	ds
	mov al,[si]
	es
	mov [di],al
	inc si
	inc di
	dec cx
	jnz strcp2 
	
ret
;--------------------------------------------------------

;-----------------------------------------------------------
;jump disk table
addressld dw 0
address dw 0
ddisk:
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
labels          db      'MY LABEL    '
id              db      'FAT12   '
;--------------------------------------------------------
;calcalation of root directory sector this sector + sfat X tfat 
eess            dw      0
;calculation strack X HEADS
ees1            dw      0
nop
ees:
;--------------------------------------------------------
labeli db 9,4
labeliii db 'LOAD     ',13,10,'$' ,0
