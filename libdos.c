//bcc -c -Md libdos.c -o libdos.a

void start();
void end();
void start(){
	main();
}

void end(){
	asm	"mov ah,0";
	asm	"int 0x21";
	halt:
	goto halt;
}

