# blue-boot
Boot disket
on data directory you must use letter on caps lock
#.COM is the start up object
version 0.03v int 21h ah=1 ah=2 ah=9 ah=0ah  ah=5 ah=6 ah=8 ah=7
ah=4c ah=0bh
int 21h and int F0h are ocupate int F0h is use to emulate int 21h
add auto exec on startup to file AUTO.COM add mzload.com than loads mz .exe  name LOAD.EXE than dont have relocation relative


are 3 special files file 0 console output screen ,file 1 console input keyboard , file 2 printer output , 3 drivers ,files from disk are not yet implemented


