# 318850575 Avital Livshitz
.data                          # data of the 2 pstrings and the choice
choice:         .int    0
.section	.rodata			    # read only data section
formatstr:      .string " %s"
formatint:      .string " %hhu"
.align      8
	.text
	.global run_main
	.type	run_main, @function
run_main:
    pushq	%rbp		        # save the old frame pointer
    movq	%rsp,       %rbp	# create the new frame pointer
    sub     $528,       %rsp    # so rsp wiil be devided by 16
    xor     %rax,       %rax    # rax = 0 to call scanf for the first pstring length
    movq    $formatint, %rdi
    leaq    (%rsp),     %rsi    # call scanf
    call    scanf
    xor     %rax,       %rax    # rax = 0 to call scanf for the first pstring
    movq    $formatstr, %rdi
    leaq    1(%rsp),    %rsi    # call scanf
    call    scanf
    xor     %rax,       %rax     # rax = 0 to call scanf for the seond pstring length
    movq    $formatint, %rdi
    leaq    257(%rsp),  %rsi    # call scanf
    call    scanf
    xor     %rax,       %rax    # rax = 0 to call scanf for the second pstring
    movq    $formatstr, %rdi
    leaq    258(%rsp),  %rsi    # call scanf
    call    scanf
    xor     %rax,       %rax    # rax = 0 to call scanf for the choice in the jump table
    movq    $formatint, %rdi
    movq    $choice,    %rsi    # call scanf
    call    scanf
    leaq    (%rsp),     %rdi    # calling func_select
    leaq    257(%rsp),  %rsi
    movq    $choice,    %rcx
    movq    (%rcx),     %rdx
    call    run_func
    add     $528,       %rsp
    popq    %rbp                # return
    ret