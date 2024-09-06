### Hello world in x86 (AT&T syntax, using GAS assembler)

The following program dives into the basics (and some extras) of writing a hello world program for x86-64. The program was assembled with GAS (GNU Assembler) which by default uses AT&T syntax.

The program will simply print out the command line arguments that are passed at runtime: 



On macOS, some adjustments may be needed:

- Change the syscall number for write from `$1` to `$0x2000004`

`movq $0x2000004, %rax`

- Change the syscall number for exit from `$60` to `$0x2000001`

`movq $0x2000001, %rax`



Using the `as` assembler:

`as hello.s -o hello.o`

Note that we might need an additional `-arch x86_64` flag to specify the target architecture for the compilation. This is useful if we are compiling on a machine where this isn't the default architecture, such as an Apple Silicon mac.



Using the `ld` linker:

`ld -pie -o hello hello.o`

The `-pie` flag tells the linker to use position-independant code.

Note that on a mac, we might need to add the `-macosx_version_min`  and `-lSystem` flags (macOS environment is built around dynamic linking, and libSystem.dylib is an important part of this system)

`ld -macosx_version_min 10.14.0 -arch x86_64 -lSystem -o hello hello.o`