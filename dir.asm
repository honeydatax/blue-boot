org 0x100
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ax,9000h
	mov ds,ax
	mov si,0h
mloop:
	mov bx,si
	mov cx,11
	call printc
	call printenter
	add si,32
	ds
	mov al,[si]
	cmp al,0h
jnz mloop
;if not find com jump to main loop 
exitss:
int 21h
	mov ah,0
int 21h
halts:
jmp halts
;-------------------------------------------------------------
;print char
printc:
push ax
push bx
push cx
push dx
push si
push di
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
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
;----------------------------------------------------------
printenter:
push ax
push bx
push cx
push dx
push si
push di
push ds
 mov ax,cs
 mov ds,ax
 mov ah,9
 mov dx,enters
 int 21h
pop ds
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
;----------------------------------------------------------
enters db 13,10,'$'
label db 13,10,'rum program auto change this program name to auto exec on start',13,10,'$' ,0
names db 13,10,'AUTO',13,10,'$' ,0
