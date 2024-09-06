.code64

.data

    buffer:
    .space 1

.text

    .global _main

    _main:
        # argc should be in %rdi by convention
        # argv should be in %rsi by convention

        # but we'll use %rdx as the pointer to argv
        movq %rsi, %rdx
        # make sure rsi points to a buffer instead
        leaq buffer(%rip), %rsi

        # make sure argc not zero
        test %edi, %edi
        je _done

        # set buffer to ascii val of argc
        movb $48, %al
        addb %dil, %al
        movb %al, (%rsi)

        call _print

        # print newline
        movb $10, (%rsi)
            
        call _print

        # use rcx as counter for args
        xor %rcx, %rcx

        # access first character pointer
        movq (%rdx), %rax

    _read:
        # test for null terminator
        movb (%rax), %sil
        test  %sil, %sil
        je _next_arg

        # print character
        movq %rax, %rsi
        call _print

        # inc the character pointer and loop
        inc %rax
        jmp _read


    _print:
        #preserve %rax, %rdi, %rdx
        pushq %rdi
        pushq %rdx
        pushq %rax
        pushq %rcx

        # %rsi contains the char pointer
        movq $0x2000004, %rax
        movq $1, %rdi
        movq $1, %rdx
        syscall

        popq %rcx
        popq %rax
        popq %rdx
        popq %rdi
        ret

    _next_arg:

        inc %rcx

        # make sure arg counter is less than argc
        cmpq %rcx, %rdi
        je _done

        # add a space
        movb $32, %al
        leaq buffer(%rip), %rsi
        movb %al, (%rsi)
        call _print

        # access char *argv[n+1]
        addq $8, %rdx
        movq (%rdx), %rax
        jmp _read  

    _done:
        # print a newline
        movb $10, %al
        leaq buffer(%rip), %rsi
        movb %al, (%rsi)

        call _print

        # exit
        movq $0x2000001, %rax
        xor %rdi, %rdi
        syscall