org 0x100
;---------------------------------------------
;kernel blue
;set vector
	call area
;main loop
loop1:
	mov ax,cs
	mov ds,ax
	mov ah,9
	mov dx,label
;write kernel message
int 240
	mov ax,cs
	mov ds,ax
	mov ah,0ah
	mov dx,labeli
;input a string
int 240
	mov ax,cs
	mov ds,ax
	mov ah,9
	mov dx,labelii
;print enter
int 240
	mov ax,cs
	mov ds,ax
	mov si,labeli
	inc si
	cs
	mov cl,[si]
	mov ch,0
	mov bx,labeliii
;print the string input
call printc
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
	push cx
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
	mov ax,cs
	mov ds,ax
ret
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
label db 13,10,'kernel version 0.04v',13,10,'$' ,0
labelii db 13,10,"$",0
labeli db 9,0
labeliii db '          ',13,10,'$' ,0
labeliiii db "  $",0
