.data
.section	.rodata			# read only data section
formatstr:     .string " %s"
formatint:   .string " %d"
default:    .string "invalid option!\n"
.align      8
	.text	# the beginnig of the code
	.global run_main
	.type	run_main, @function	# the label "main" representing the beginning of a function
run_main:
    pushq	%rbp		        # save the old frame pointer
    movq	%rsp,       %rbp	# create the new frame pointer
    xor     %rax,       %rax    # rax = 0 to call scanf for the first int
    movq    $formatint, %rdi    # the format of the read from scanf
    sub     $16,        %rsp    # allocate space for scanf that devides in 16
    leaq    8(%rsp),    %rsi    # call scanf
    call    scanf