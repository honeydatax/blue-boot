org 0x100
	mov ah,0
	mov al,3
int 10h
	mov ah,0
int 240
halt:
jmp halt
names db 13,10,'CLS',13,10,'$' ,0
