#include <stdio.h>
#include <stdlib.h>

int main(int argc,char *argv[]){
	FILE *f1;
	FILE *f2;
	char buff[513];
	if (argc>2 ){
		f1=fopen(argv[1],"r");
		f2=fopen(argv[2],"r+");
			fread(buff,2,1,f1);
			fwrite(buff,2,1,f2);
			fread(buff,57,1,f1);
			fread(buff,57,1,f2);
			fread(buff,510-57-2-1,1,f1);
			fwrite(buff,510-57-2-1,1,f2);
		fclose(f1);
		fclose(f2);
		printf ("%s %s",argv[1],argv[2]);
	}
}
