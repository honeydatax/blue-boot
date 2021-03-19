org 0x100
;---------------------------------------------
;kernel blue
;set vector
	mov ax,cs
	cmp ax,0x1000
	jz areas
	mov ah,0
int 0x21
areas:
	call area
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
;--------------------------------------------------------------
;calcalation of root directory sector this sector + sfat X tfat 		cs
		cs
		mov bx,[eess]
        mov ax,9000h
        cs
        mov [addressld],ax
        mov ax,0h
        cs
        mov [address],ax
        mov es,ax
        mov ax,bx
;load root directory
call func

	mov ax,cs
	mov es,ax
	mov ds,ax
	mov ax,cs
	mov ds,ax
	mov ah,9
	mov dx,label
;write kernel message
int 240
;main loop
jmp loop10
loop1:
	mov ax,0ffffh
	mov sp,ax
	mov ax,cs
	mov ss,ax
	mov ds,ax
	mov es,ax
	mov ax,cs
	mov ax,cs
	mov es,ax
	mov ds,ax
	mov ax,cs
	mov ds,ax
	mov ah,9
	mov dx,labelii3
;write kernel prompt
int 240
	mov ax,cs
	mov ds,ax
	mov ah,0ah
	mov dx,labeli
;input a string
int 240
loop10:
	mov ax,cs
	mov ds,ax
	mov ah,9
	mov dx,labelii
;print enter
int 240
jmp exec
jmp loop1
	call halts
;--------------------------------------------------------------
;int 21h , 9
print:
	mov bx,dx
;main loop
print1:
	ds
	mov dl,[bx]
	cmp dl,'$'
	jz print2
	cmp dl,0
jz print2
;write char if not $
	mov ah,2
int 240
	inc bx
jmp print1
print2:
;return pop iret
jmp irets
;----------------------------------------------------------
;int 21h , 2
printchr:
	mov al,dl
	mov ah,0eh
	mov bl,7
	mov bh,0
;print char in tty mode
int 10h
;return pop iret
jmp irets
;------------------------------------------------------------
;int 21h , 1
inputx:
	mov ax,0
;get key
int 16h
	mov dl,al
	mov ah,2
;print the char
int 240
	pop cx
jmp irets2
;------------------------------------------------------------
;
inputs:
	mov ah,1
int 240
jmp irets
;---------------------------------------------------------
;
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
;get key
int 16h
	cmp al,8
;jmp if not chr delete backspace
jnz kinput3
	cmp ch,0
;check for max char count
jz kinput2
	dec ch
	dec di
	push cx
	mov ah,3
	mov bh,0
; on delete back space keys , back the cursor
int 10h
;backspace calc line
	cmp dl,0
jnz kinput4
	mov dl,79
dec dh
kinput4:
	dec dl
	mov bh,0
	mov ah,2
;back space key ajust cursor
int 10h
	mov ah,0ah
	mov al,32
	mov cx,2
	mov bl,7
	mov bh,0
;print space chat on back space place
int 10h
	pop cx
jmp kinput2
kinput3:
	cmp al,13
;jmp if enter key press
jz kinput8
	cmp cl,ch
;check if max chat 
jz kinput2
	ds
	mov [di],al
	inc di
	inc ch
	mov dl,al
	mov ah,2
;print the char on the screen
int 240
jmp kinput2
kinput8:
	dec si
	ds
	mov [si],ch
;iret ipop
jmp irets
;-----------------------------------------------------------
;int get dos version
gver:
	mov al,5
	mov ah,0
	mov bh,0
	mov cx,0
	pop dx
	pop dx
	pop dx
jmp irets10
;-------------------------------------------------------------
;print char
printc:
printc2:
	ds
	mov dl,[bx] 
	mov ah,2
;print same char
int 240
	inc bx
	dec cx
	cmp cx,0
;check if max char is on
jnz printc2
ret
;-------------------------------------------------------------
;function 21_6
function6:
	cmp dl,0xff
jz function6_1
	mov ah,2
	int 0x21
	pop cx
jmp irets2
function6_1:
	mov ah,0
	int 0x16
pop cx
jmp irets2
;-------------------------------------------------------------
;function 21_5
function5:
	mov ah,0
	mov al,dl
	mov dx,0
int 0x17
		pop cx
jmp irets2
;-------------------------------------------------------------
;function 21_7
function7:
	mov ah,0
int 0x16
	pop cx
jmp irets2
;-------------------------------------------------------------

;----------------------------------------------------------
;----------------------------------------------------------
;halts function
halts:
jmp halts
;-----------------------------------------------------------
;define int 21h int vector
area:
vectors:
;int f0h define on vector 960
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
;----------------------------
;int 21h define on vector 132
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
;----------------------------
;int 20h define on vector 128
	mov ax,0
	mov ds,ax
	mov ax,vectors20i
	mov dx,cs
	mov di,128
	vectors3:
	ds
	mov [di],ax
	add di,2
	ds
	mov [di],dx
	add di,2
;---------------------------
	mov ax,cs
	mov ds,ax

ret
;---------------------------
;int vector 20h
vectors20i:
jmp loop1
;---------------------------
;int vector 21h f0h
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
	cmp ah,0
jnz crts1
jmp loop1
crts1:
	cmp ah,1
jnz crts2
jmp inputx
crts2:
	cmp ah,2
jnz crts3
jmp printchr
crts3:
crts5:
	cmp ah,5
jnz crts6
jmp function5
crts6:
	cmp ah,6
jnz crts7
jmp function6
crts7:
	cmp ah,7
jnz crts8
jmp function7
crts8:
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
crts4c:
	cmp ah,0x4c
jnz crts4d
jmp loop1
crts4d:
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
exec:
	mov ax,2000h
	cs
	mov [addressld],ax
	mov ax,100h
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
;put 2000h:100h in stack to jump to 1000h:100h
;call printe
;jmp loop1

	mov ax,2000h
	mov es,ax
	mov ds,ax
	mov ss,ax
	mov ax,0ffffh
	mov sp,ax
	mov ax,0x2000
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
;jump to 2000h:100h
retf
;--------------------------------------------------------
ret
;--------------------------------------------------------

;--------------------------------------------------------
printe:
	mov ax,100h
	mov bp,ax
	mov ax,2000h
	mov es,ax
	mov bh,0
	mov bl,1
	mov dl,1
	mov dh,1
	mov cx,1500
	mov al,1
	mov ah,13h
int 10h
ret
;--------------------------------------------------------
label db 13,10,'kernel version 0.04v',13,10,'$' ,0
labelii db 13,10,"$",0
labeli db 9,4
labeliii db 'AUTO     ',13,10,'$' ,0
labeliiii db "  $",0
labelii3 db 13,10,"BLUE>$",0
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
