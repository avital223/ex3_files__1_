# 318850575 Avital Livshitz
.section	.rodata			# read only data section
format:     .string " %c %c"
frm2ints:   .string " %hhu"
case50or60: .string "first pstring length: %d, second pstring length: %d\n"
case52:     .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
case55:     .string "compare result: %d\n"
case53or54: .string "length: %d, string: %s\nlength: %d, string: %s\n"
default:    .string "invalid option!\n"
.align      8
	.text	# the beginnig of the code
	.global func_select
	.type	func_select, @function
    .L10:
        .quad .L4 # case 50
        .quad .L9 # case 51
        .quad .L5 # case 52
        .quad .L6 # case 53
        .quad .L7 # case 54
        .quad .L8 # case 55
        .quad .L9 # case 56
        .quad .L9 # case 57
        .quad .L9 # case 58
        .quad .L9 # case 59
        .quad .L4 # case 60

    .L4:                            # case 50 or 60
        call    pstrlen             # calculates the length of the first pstring which is saved in rdi already.
        movzbq  %al,        %rsi    # the resault it saves in the second argument we send later to printf
        movq    -16(%rbp),  %rdi    # put the secong pstring in rdi
        call    pstrlen
        movzbq  %al,        %rdx    # the resault it saves in the third argument we send later to printf
        mov     $case50or60,%rdi    # the line we want to print
        jmp     .L3

    .L5:                            # case 52
        xor     %rax,       %rax    # rax = 0 to call scanf
        movq    $format,    %rdi    # the format of the read from scanf
        push    %r12                # so we can run the register later
        sub     $24,        %rsp    # allocate space for scanf that devides in 16 (8+24=32)
        leaq    8(%rsp),    %rsi    # call scanf
        leaq    (%rsp),     %rdx
        call    scanf
        mov     -8(%rbp),   %rdi    #call replacechar for the first pstring
        movzbq  8(%rsp),    %rsi
        movzbq  (%rsp),     %rdx
        call    replaceChar
        leaq    1(%rax),    %r12    # save the result in r12
        mov     -16(%rbp),  %rdi    # call replacechar for the second pstring
        movzbq  8(%rsp),    %rsi
        movzbq  (%rsp),     %rdx
        call    replaceChar
        movq    %r12,       %rcx    # prepare for the printf
        leaq    1(%rax),    %r8
        mov     $case52,    %rdi
        movzbq  8(%rsp),    %rsi
        movzbq  (%rsp),     %rdx
        addq    $24,        %rsp    # delete the memory we allocated
        pop     %r12
        jmp     .L3

    .L6:                            # case 53
        xor     %rax,       %rax    # rax = 0 to call scanf for the first int
        movq    $frm2ints,  %rdi    # the format of the read from scanf
        sub     $16,        %rsp    # allocate space for scanf that devides in 16
        leaq    8(%rsp),    %rsi    # call scanf
        call    scanf
        xor     %rax,       %rax    # rax = 0 to call scanf to the second int
        movq    $frm2ints,  %rdi    # the format of the read from scanf
        leaq    (%rsp),     %rsi
        call    scanf
        movq    -8(%rbp),   %rdi    #call copy pstring
        movq    -16(%rbp),  %rsi
        movzbq  8(%rsp),    %rdx
        movzbq  (%rsp),     %rcx
        call    pstrijcpy
        movzbq  (%rax),     %rsi    # prepare for printf
        leaq    1(%rax),    %rdx
        movq    -16(%rbp),  %r9
        movzbq  (%r9),      %rcx
        leaq    1(%r9),     %r8
        movq    $case53or54,%rdi
        addq    $16,        %rsp    # delete the memory we allocated
        jmp     .L3

    .L7:                            # case 54
        push    %r12                # to use the register r12
        call    swapCase            # call swapCase with the first pstring that already in the rdi
        leaq    (%rax),     %r12    # the new pstring we put in r12
        movq    -16(%rbp),  %rdi    # call swapCase with the secong pstring
        call    swapCase
        movzbq  (%rax),     %rcx    # call printf to the 2 pstrings
        leaq    1(%rax),    %r8
        movzbq  (%r12),     %rsi
        leaq    1(%r12),    %rdx
        mov     $case53or54,%rdi
        pop     %r12                # restore the register r12
        jmp     .L3

    .L8:                            # case 55
        xor     %rax,       %rax    # rax = 0 to call scanf for the first int
        movq    $frm2ints,  %rdi    # the format of the read from scanf
        sub     $16,        %rsp    # allocate space for scanf that devides in 16
        leaq    8(%rsp),    %rsi    # call scanf
        call    scanf
        xor     %rax,       %rax    # rax = 0 to call scanf to the second int
        movq    $frm2ints,  %rdi    # the format of the read from scanf
        leaq    (%rsp),     %rsi
        call    scanf
        movq    -8(%rbp),   %rdi    #call compare pstring
        movq    -16(%rbp),  %rsi
        movzbq  8(%rsp),    %rdx
        movzbq  (%rsp),     %rcx
        call    pstrijcmp
        movq    %rax,       %rsi    # prepare for printf
        movq    $case55,    %rdi
        addq    $16,        %rsp    # delete the memory we allocated
        jmp     .L3

    .L9:                                # default
        mov     $default, %rdi          # prepare for printf
        jmp     .L3

    .L3:                                # calling printf in the end of the case
        xor    %eax,    %eax            # Zeroing EAX is efficient way to clear AL.
        call   printf                   # call printf with the arfuments already set in each case
        mov    $0,      %rax            # return here from the function
        popq   %rsi
        popq   %rdi
        popq   %rbp
        ret

func_select:
	pushq	%rbp		        # save the old frame pointer
	movq	%rsp,       %rbp	# create the new frame pointer
	pushq   %rdi                # save the pointers to the pstrings in the stack
	pushq   %rsi
    leaq    -50(%rdx),  %rcx    # the jump table (switch-case)
    cmp     $10,        %rcx
    ja      .L9
    jmp     *.L10(,%rcx,8)


