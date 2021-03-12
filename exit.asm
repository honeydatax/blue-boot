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
label db 13,10,'turn off you pc',13,10,'$' ,0
names db 13,10,'EXIT',13,10,'$' ,0
