# 318850575 Avital Livshitz
.data                          # data of the 2 pstrings and the choice
first_s:        .fill 257
second_s:       .fill 257
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
    xor     %rax,       %rax    # rax = 0 to call scanf for the first pstring length
    movq    $formatint, %rdi
    movq    $first_s,   %rsi    # call scanf
    call    scanf
    xor     %rax,       %rax    # rax = 0 to call scanf for the first pstring
    movq    $formatstr, %rdi
    movq    $first_s,   %rsi    # call scanf
    inc     %rsi
    call    scanf
    xor     %rax,       %rax    # rax = 0 to call scanf for the seond pstring length
    movq    $formatint, %rdi
    movq    $second_s,  %rsi    # call scanf
    call    scanf
    xor     %rax,       %rax    # rax = 0 to call scanf for the second pstring
    movq    $formatstr, %rdi
    movq    $second_s,  %rsi    # call scanf
    inc     %rsi
    call    scanf
    xor     %rax,       %rax    # rax = 0 to call scanf for the choice in the jump table
    movq    $formatint, %rdi
    movq    $choice,    %rsi    # call scanf
    call    scanf
    movq    $first_s,   %rdi    # calling func_select
    movq    $second_s,  %rsi
    movq    $choice,    %rcx
    movq    (%rcx),     %rdx
    call    func_select
    popq    %rbp                # return
    ret