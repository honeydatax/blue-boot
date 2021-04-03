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
	;close all files
	mov ax,0x8000
	mov es,ax
	mov cx,10710
	mov bx,0
	mov al,0
close_all_files:
	es
	mov [bx],al
	inc bx
	dec cx
	cmp cx,0
jnz close_all_files
	;open file 0 console for output
	mov ax,0x8000
	mov es,ax
	mov bx,0
	mov ax,0x101
	es
	mov [bx],ax
	clc
	add bx,42
	es
	mov [bx],ax
	clc
	add bx,42
	es
	mov [bx],ax
	clc
	add bx,42
	es
	mov [bx],ax
	;reset command line
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
;-------------------------------------------------------------
;function 21_b
functionb:
	mov ah,1
int 0x16
jz functionb_1
		mov al,0
	pop cx
jmp irets2
functionb_1:
		mov al,0xff
	pop cx
jmp irets2
;-------------------------------------------------------------
;function 21_c
functionc:
	mov cx,32
	mov ax,0x40
	mov ds,ax
	mov bx,0x1e
	mov al,0
functioncloop:
		ds
		mov [bx],al
		inc bx
		dec cx
		cmp cx,0
	jnz functioncloop
	mov ax,cs
	mov ds,ax	
	mov ah,1
int 0x16
jz functionc_1
		mov al,0
	pop cx
jmp irets2
functionc_1:
	pop cx
jmp irets2
;-------------------------------------------------------------
;function 21_25
function25:
	mov ah,0
	push dx
	mov dx,0
	mov cx,0
	mov bx,4
	clc
	mul bx
	pop dx
	mov cx,ds
	mov bx,ax
	mov ax,0
	mov ds,ax
	ds
	mov [bx],dx
	inc bx
	inc bx
	ds
	mov [bx],cx 
jmp irets
;----------------------------------------------------------
;function 21_35
function35:
	mov ah,0
	mov dx,0
	mov cx,0
	mov bx,4
	clc
	mul bx
	mov bx,ax
	mov ax,0
	mov ds,ax
	ds
	mov dx,[bx]
	inc bx
	inc bx
	ds
	mov cx,[bx]
	mov es,cx
	mov bx,dx 

	pop ax
	pop cx
	pop dx
	pop dx
	pop ds
	pop ds
	pop di
	pop si
	pop bp
iret
;----------------------------------------------------------
;function 21_4b
function4b:
	mov si,dx
	mov di,labeliii
	mov cl,0
function4b_1:
	ds
	mov al,[si]
	cs
	mov [di],al
	inc si
	inc di
	inc cl
	cmp al,0
jnz function4b_1
	mov di,labeli
	inc di
	dec cl
	cs
	mov [di],cl
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
jmp loop10
;----------------------------------------------------------
;function 21_2c
function2c:
	mov ah,2
	int 0x1a
	push cx
	push dx
	mov si,sp
	;---------
	ss
	mov bh,[si+3]
	ss
	mov al,[si+3]
	and al,0xf0
	and bh,0xf
	shr al,4
	mov cx,0
	mov dx,0
	mov bl,10
	clc 
	mul bl
	mov ah,0
	clc
	add al,bh
	ss
	mov [si+3],al
	;------------
	;---------
	ss
	mov bh,[si+2]
	ss
	mov al,[si+2]
	and al,0xf0
	and bh,0xf
	shr al,4
	mov cx,0
	mov dx,0
	mov bl,10
	clc 
	mul bl
	mov ah,0
	clc
	add al,bh
	ss
	mov [si+2],al
	;------------
	;---------
	ss
	mov bh,[si+1]
	ss
	mov al,[si+1]
	and al,0xf0
	and bh,0xf
	shr al,4
	mov cx,0
	mov dx,0
	mov bl,10
	clc 
	mul bl
	mov ah,0
	clc
	add al,bh
	ss
	mov [si+1],al
	;------------
	pop dx
	pop cx
	;-------
	pop ax
	pop bx
	pop bx
	pop es
	pop es
	pop ds
	pop di
	pop si
	pop bp
iret
;----------------------------------------------------------
;----------------------------------------------------------
;function 21_2a
function2a:
	mov ah,4
	int 0x1a
	push cx
	push dx
	mov si,sp
	;---------
	ss
	mov bh,[si+3]
	ss
	mov al,[si+3]
	and al,0xf0
	and bh,0xf
	shr al,4
	mov cx,0
	mov dx,0
	mov bl,10
	clc 
	mul bl
	mov ah,0
	clc
	add al,bh
	ss
	mov [si+3],al
	;------------
	;---------
	ss
	mov bh,[si+2]
	ss
	mov al,[si+2]
	and al,0xf0
	and bh,0xf
	shr al,4
	mov cx,0
	mov dx,0
	mov bl,10
	clc 
	mul bl
	mov ah,0
	clc
	add al,bh
	ss
	mov [si+2],al
	;------------
	ss
	mov al,[si+3]
	mov ah,0
	mov cx,0
	mov dx,0
	mov bx,100
	clc
	mul bx
	mov dx,ax
	mov al,[si+2]
	mov ah,0
	clc 
	add ax,dx
	mov [si+2],ax
	;---------
	ss
	mov bh,[si+1]
	ss
	mov al,[si+1]
	and al,0xf0
	and bh,0xf
	shr al,4
	mov cx,0
	mov dx,0
	mov bl,10
	clc 
	mul bl
	mov ah,0
	clc
	add al,bh
	ss
	mov [si+1],al
	;------------
	;---------
	ss
	mov bh,[si+0]
	ss
	mov al,[si+0]
	and al,0xf0
	and bh,0xf
	shr al,4
	mov cx,0
	mov dx,0
	mov bl,10
	clc 
	mul bl
	mov ah,0
	clc
	add al,bh
	ss
	mov [si+0],al
	;------------
	pop dx
	pop cx
	mov ax,0x2a00
	;-------
	pop bx
	pop bx
	pop bx
	pop es
	pop es
	pop ds
	pop di
	pop si
	pop bp
iret
;----------------------------------------------------------
;function 21_2d
function2d:
	push cx
	push dx
	mov si,sp
	;---------------
	ss
	mov al,[si+3]
	ss
	mov dh,[si+3]
	mov bl,10
	mov ah,0
	clc 
	div bl
	clc
	mov dl,al
	mov ah,0
	mov bl,10
	clc
	mul bl
	clc
	sub dh,al
	clc
	shl dl,4
	or dl,dh
	ss
	mov [si+3],dl
	;------------
	;---------------
	ss
	mov al,[si+2]
	ss
	mov dh,[si+2]
	mov bl,10
	mov ah,0
	clc 
	div bl
	clc
	mov dl,al
	mov ah,0
	mov bl,10
	clc
	mul bl
	clc
	sub dh,al
	shl dl,4
	or dl,dh
	ss
	mov [si+2],dl
	;------------
	;---------------
	ss
	mov al,[si+1]
	ss
	mov dh,[si+1]
	mov bl,10
	mov ah,0
	clc 
	div bl
	clc
	mov dl,al
	mov ah,0
	mov bl,10
	clc
	mul bl
	clc
	sub dh,al
	shl dl,4
	or dl,dh
	ss
	mov [si+1],dl
	;------------
	pop dx
	pop cx
	;-----------
	mov ah,3
	mov al,0
	mov dl,0
	int 0x1A
	
jmp irets
;----------------------------------------------------------
;----------------------------------------------------------
;function 21_2b
function2b:
	push cx
	push dx
	mov si,sp
	;---------------
	ss
	mov ax,[si+2]
	ss
	mov di,[si+2]
	mov bx,100
	mov cx,0
	mov dx,0
	clc 
	div bx
	ss
	mov [si+3],al
	mov bx,100
	mov cx,0
	mov dx,0
	clc 
	mul bx
	mov dx,di
	clc
	sub dx,ax
	ss
	mov [si+2],dl
	;------------
	;---------------
	ss
	mov al,[si+3]
	ss
	mov dh,[si+3]
	mov bl,10
	mov ah,0
	clc 
	div bl
	clc
	mov dl,al
	mov ah,0
	mov bl,10
	clc
	mul bl
	clc
	sub dh,al
	clc
	shl dl,4
	or dl,dh
	ss
	mov [si+3],dl
	;------------
	;---------------
	ss
	mov al,[si+2]
	ss
	mov dh,[si+2]
	mov bl,10
	mov ah,0
	clc 
	div bl
	clc
	mov dl,al
	mov ah,0
	mov bl,10
	clc
	mul bl
	clc
	sub dh,al
	clc
	shl dl,4
	or dl,dh
	ss
	mov [si+2],dl
	;------------
	;---------------
	ss
	mov al,[si+1]
	ss
	mov dh,[si+1]
	mov bl,10
	mov ah,0
	clc 
	div bl
	clc
	mov dl,al
	mov ah,0
	mov bl,10
	clc
	mul bl
	clc
	sub dh,al
	shl dl,4
	or dl,dh
	ss
	mov [si+1],dl
	;------------
	;---------------
	ss
	mov al,[si+0]
	ss
	mov dh,[si+0]
	mov bl,10
	mov ah,0
	clc 
	div bl
	clc
	mov dl,al
	mov ah,0
	mov bl,10
	clc
	mul bl
	clc
	sub dh,al
	shl dl,4
	or dl,dh
	ss
	mov [si+0],dl
	;------------
	pop dx
	pop cx
	;-----------
	mov ah,5
int 0x1A
	
jmp irets
;----------------------------------------------------------
;function21_19:
function19:
mov ax,0x1900
	pop bx
jmp irets2
;----------------------------------------------------------
;----------------------------------------------------------
;function21_e:
functione:
mov ax,0xe01
	pop bx
jmp irets2
;----------------------------------------------------------
;function21_2f:
function2f:
	cs
	mov bx,[ipsDTA]
	cs
	mov ax,[segDTA]
	mov es,ax
	pop ax
	pop cx
	pop dx
	pop dx
	pop ds
	pop ds
	pop di
	pop si
	pop bp
iret
;----------------------------------------------------------
;function21_1a:
function1a:
	mov ax,ds
	cs
	mov [ipsDTA],dx
	cs
	mov [segDTA],ax
jmp irets
;----------------------------------------------------------
;----------------------------------------------------------
;function21_3d:
function3d:
	push ax
	mov cl,0
	mov di,labeliii
	mov si,dx
function3d_copy:
	ds
	mov al,[si]
	cs
	mov [di],al
	inc si
	inc di
	inc cl
	cmp al,0
	jnz function3d_copy
	dec cl
	mov di,labeli+1
	cs
	mov [di],cl
	mov cl,0
	mov ax,0x8000
	mov es,ax
	mov bx,0
function3d_1:
	cmp cl,225
	jnz function3d_2
	pop ax
	jmp function3d_end
function3d_2:
	es
	mov al,[bx]
	cmp al,0
	jnz function3d_3
	jmp function3d_file
function3d_3:
		clc 
		add bx,42
		inc cl
		jmp function3d_1
function3d_file:
	mov ch,1
	es
	mov [bx],ch
	pop ax
	push cx
	inc bx
	es
	mov [bx],al
	mov ax,0
	inc bx
	es
	mov [bx],ax
	inc bx
	inc bx
	es
	mov [bx],ax
	inc bx
	inc bx
	push es
	push bx
	mov ax,0x9000
	mov es,ax
	mov si,0h
function3d_mloop:
	cs
	mov cl,[labeli+1]
	mov di,labeliii
	mov bp,si
	function3d_mmloop:
		es
		mov al,[bp]
		cs
		mov ah,[di]
		inc bp
		inc di
		cmp al,ah
		jnz function3d_mloop10 
		dec cl
		jnz function3d_mmloop
	jmp function3d_mloop1
	function3d_mloop10:
	add si,32
	cmp si,300h
jb function3d_mloop  
;if not find com jump to main loop 
	pop bx
	pop es
	sub bx,6
	mov ax,0
	es
	mov [bx],ax 
	pop ax
jmp function3d_end
function3d_mloop1:
;--------------------------------------------------------
;retrive sector number of root directory table
	pop di
	pop ds
	mov cl,32
function3d_copy_2:
	es
	mov al,[si]
	ds
	mov [di],al
	inc si
	inc di
	dec cl
	cmp cl,0
	jnz function3d_copy_2
function3d_copy_end:
	pop ax
	mov ah,0
	pop bx
	stc
jmp irets2
function3d_end:
	mov ax,255
	clc
	pop bx
jmp irets2
;----------------------------------------------------------
;function 21_40
function40:
	cmp bl,0
	jz function40_1
	jmp function40_3
; file n 0 output console screen
function40_1:
	push cx
	mov bx,dx
function40_loop:
	ds
	mov dl,[bx]
	mov ah,2
int 0x21
	inc bx
	dec cx
	cmp cx,0
jnz function40_loop
	pop ax
	pop bx
jmp irets2
; file n 2 output printer 1
function40_3:
	cmp bl,2
	jz function40_12
	jmp function40_4
function40_12:
	push cx
	mov bx,dx
function40_loop2:
	mov dx,0
	ds
	mov al,[bx]
	mov ah,0
int 0x17
	inc bx
	dec cx
	cmp cx,0
jnz function40_loop2
	pop ax
	pop bx
jmp irets2
; file n 3 com printer output
function40_4:
	cmp bl,3
	jz function40_13
	jmp function40_2
function40_13:
	push cx
	mov bx,dx
function40_loop3:
	mov dx,0
	ds
	mov al,[bx]
	mov ah,1
int 0x14
	inc bx
	dec cx
	cmp cx,0
jnz function40_loop3
	pop ax
	pop bx
jmp irets2
function40_2:
	mov ax,0
	pop bx
jmp irets2
;----------------------------------------------------------
;function 21_3f
function3f:
	cmp bl,1
	jz function3f_1
	jmp function3f_3
function3f_1:
	push cx
	mov bx,dx
function3f_loop:
	mov ah,1
int 0x21
	ds
	mov [bx],al
	inc bx
	dec cx
	cmp cx,0
jnz function3f_loop
	pop ax
	pop bx
jmp irets2
function3f_3:
	cmp bl,3
	ja function3f_8
	jmp function3f_2
function3f_8:
	push cx
	push ds
	push dx
	mov ax,0x8000
	mov ds,ax
	mov ax,42
	mov bh,0
	clc 
	mul bx
	mov bx,ax
	ds
	mov al,[bx]
	cmp al,0
jnz function3f_9
jmp function3f_16
function3f_9:
	cs
	mov [ipsDTAsel],bx
	inc bx
	ds
	mov al,[bx]
	cmp al,0
jz function3f_10
	cmp al,2
jz function3f_10
jmp function3f_16
function3f_10:
	clc
	add bx,0x1a
	clc
	add bx,5
	ds
	mov ax,[bx]
	push ax
	mov bx,segDTA
	cs
	mov ax,[bx]
	cs
	mov [addressld],ax
	mov bx,ipsDTA
	cs
	mov ax,[bx]
	cs
	mov [address],ax
    pop ax
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
    
 ;load file
 push cs
 push cs
 pop ds
 pop es
call func
	cs
	mov ax,0x8000
	mov ds,ax
	cs
	mov si,[ipsDTAsel]
	clc
	add si,2
	ds
	mov dx,[si]
	pop bx
	pop es
	pop cx
	push dx
	add dx,cx
	ds
	mov [si],dx
	cs
	mov ax,[segDTA]
	mov ds,ax
	pop di
	clc
	add di,0x8000
	push cx
function3f_loop_8:	
	ds
	mov al,[di]
	es
	mov [bx],al
	inc bx
	inc di
	dec cx
jnz function3f_loop_8
	pop ax
	pop bx
jmp irets2
function3f_16:
	pop dx
	pop ds
	pop ax
	pop bx
jmp irets2
function3f_2:
	mov ax,0
	pop bx
jmp irets2
;----------------------------------------------------------
;function 21_3e
function3e:
	mov bh,0
	mov ax,42
	mov cx,0
	mov dx,0
	clc
	mul bx
	mov bx,ax
	mov ax,0x8000
	mov es,ax
	mov cl,42
	mov al,0
function3e_loop:
		es
		mov [bx],al
		inc bx
		dec cl
jnz function3e_loop
jmp irets
;----------------------------------------------------------
;----------------------------------------------------------
;----------------------------------------------------------
;----------------------------------------------------------
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
	cmp ah,8
jnz crts9
jmp function7
crts9:
	cmp ah,9
jnz crts10
jmp print
crts10:
	cmp ah,0ah
jnz crts11
jmp kinput
crts11:
	cmp ah,0bh
jnz crtsc
jmp functionb
crtsc:
	cmp ah,0ch
jnz crtsd
jmp functionc
crtsd:
crtse:
	cmp ah,0eh
jnz crtsf
jmp functione
crtsf:
crts19:
	cmp ah,19h
jnz crts1a
jmp function19
crts1a:
	cmp ah,1ah
jnz crts1b
jmp function1a
crts1b:
crts25:
	cmp ah,025h
jnz crts26h
jmp function25
crts26h:
crts2a:
	cmp ah,02ah
jnz crts2bh
jmp function2a
crts2bh:
	cmp ah,02bh
jnz crts2c
jmp function2b
crts2c:
	cmp ah,02ch
jnz crts2dh
jmp function2c
crts2dh:
	cmp ah,02dh
jnz crts2eh
jmp function2d
crts2eh:
crts2fh:
	cmp ah,02fh
jnz crts30h
jmp function2f
crts30h:
	cmp ah,030h
jnz crts31h
jmp gver
crts31h:
crts35:
	cmp ah,035h
jnz crts36h
jmp function35
crts36h:
crts3d:
	cmp ah,03dh
jnz crts3eh
jmp function3d
crts3eh:
	cmp ah,0x3e
jnz crts3f
jmp function3e
crts3f:
	cmp ah,0x3f
jnz crts40
jmp function3f
crts40:
	cmp ah,0x40
jnz crts41
jmp function40
crts41:
crts4b:
	cmp ah,0x4b
jnz crts4c
jmp function4b
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
label db 13,10,'kernel version 0.06v',13,10,'$' ,0
labelii db 13,10,"$",0
labeli db 9,4
labeliii db 'AUTO     ',13,10,'$' ,0
labeliiii db "  $",0
labelii3 db 13,10,"BLUE>$",0
segDTA dw 0x9000
ipsDTA dw 0x8000
ipsDTAsel dw 0
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
