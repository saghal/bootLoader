# bootloader
bootloader is the first program run when computer start,and responsibilty of it is load and transmit control to OS kernel
and bootloader save on MBR,MBR is boot sector size of 512 bytes in first of hard disk. 
we want to write a bootloader that displays "Hello, World!nameSTDnumber". In assembly language
### Requirements

You need an assember that can convert your assembly instructions to raw binary format and an simulator to view.
I am using Nasm and Qemu simulator.

For Linux, type following commands to install [nasm](http://www.nasm.us/) & [qemu](https://qemu.weilnetz.de/)
```
	sudo apt-get install nasm
	sudo apt-get install qemu qemu-system-x86_64
```
### introduction
bootloader stored on the first sector of the disk and size of 1 sector exactly equal 512 bytes
It does that by reading the first 512 bytes from the boot devices and checks if the last two of these 512 bytes Ends with a signature `0x55AA`. If that's what these last two bytes are, the BIOS moves the 512 bytes to the memory address `0x7c00` and treats whatever was at the beginning of the 512 bytes as code, the so-called bootloader.
the CPU is running in 16 bit mode, meaning only the 16 bit registers are available and assembler is working in 16-bit [real mode](https://en.wikipedia.org/wiki/Real_mode). it will convert assembly data to 16-bit binary form.
for printing a string we don't have any OS or libraries so we must do someting else, we can use BIOS functions,like interrupts
we use interrupts to print a string, but a single interupt can prints a character given `al` and for prepare some interrupts to print more character, use a loop,size of loop equal with string size meaning continue to end of string and after any interrupt index(si) automatically go to next character in this way we can print a string of character 

### procedure

First we must specify 16 bit real mode and organize from 0x7C00 memory location where BIOS will load us

we must show from where our codes start for this we have start label `start:` (this name of start can be anything)
then in `start:` we define our string for print and labed that `hello_world`.
we point to  first character of this string specify this is our source index(si register) and after that we must print this string by interrupts, si on first character so we going to print character by character with interrupt loop that prepare by callilng `print_string`
in print_string by 0x0E service this service tell to interrupt handler take ASCII character from al and print that character by 0x10 

in interrupt loop first we load a character in `la` (in this state source index(si) automatically go to next character) and compare this character not be equal with end of string `\0`
if that character equal zero we done our printing else we continue our printing untill see `0` after that print is done

when we fill the rest of the sector with zeros 
`$` reprensents the address of the current line
`$$` is the address of the first instruction
So 510 - ($ - $$) gives us the number of bytes we need for padding


### run
following command to compile file
```
nasm -f bin boot.asm -o myos.bin
```
then run `.bin` file in QEMU
 ```
 qemu-system-x86_64 boot.bin
 ```
 
### QEMU output 
![alt text](https://3.bp.blogspot.com/-7-BBXRWCcFY/WKyUQKqy2ZI/AAAAAAAAAX4/_jtim6FGQkc7Xa1NS1IkE7ASs-uwCdbUACEw/s1600/hello_world_os.png)

### Reference
[http://createyourownos.blogspot.com/](http://createyourownos.blogspot.com/)
