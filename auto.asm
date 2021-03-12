org 0x100
	mov ax,cs
	mov ds,ax
	mov ah,9
	mov dx,label
;write kernel message
int 21h
	mov ah,0
int 21h
halts:
jmp halts
label db 13,10,'rum program auto change this program name to auto exec on start',13,10,'$' ,0
names db 13,10,'AUTO',13,10,'$' ,0
