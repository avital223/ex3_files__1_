# 318850575 Avital Livshitz
	.section	.rodata	#read only data section
str:	.string	"invalid input!\n"
	.text	#the beginnig of the code
.global pstrlen, replaceChar, swapCase, pstrijcpy, pstrijcmp
	.type	pstrlen, @function
	.type	replaceChar, @function
	.type   swapCase, @function
	.type   pstrijcpy, @function
	.type   pstrijcmp, @function

pstrlen: # the function returns the length of the pstring
    movzbq   (%rdi), %rax     #returns the first byte that contains the length
    ret

#Pstring* replaceChar(rdi - Pstring* pstr, rsi - char oldChar, rdx - char newChar);
replaceChar: # the function replaces all the first char in the pstring to the new char
    movzbq  (%rdi), %rcx    # puts length of array in rcx
    xor     %rax,   %rax    # rax = 0
    leaq    1(%rdi),%r8     # puts in r8 the pointer of the array to the string
.L12:
    cmpb    (%r8),  %sil    # compares the char in the array to the char in rsi
    jne     .L11
    movb    %dxl,   (%r8)   # replaces the char in the array to the given char
.L11:
    inc     %rax            # rax++
    inc     %r8             # moving to the next byte in the array
    cmp     %rcx,   %rax
    jb     .L12
    xor     %rax,   %rax    #returns the pointer to the same psrting
    leaq    (%rdi), %rax
    ret

# in this function I use some of the properties of the ascii table that Adam (316044809) told me
# Pstring* swapCase(rdi - Pstring* pstr);
swapCase: # this function swaps each letter from little to big and from big to little
    movzbq  (%rdi), %rsi    # puts length of array in rsi
    xor     %rax,   %rax    # rax = 0
    leaq    1(%rdi),%rdx    # pointer to the pstring
.L9:
    xor     %rcx,   %rcx    # saves the char we work on in rcx
    movb    (%rdx), %cl
    or      $0x20,   %cl    # if the char is a letter - we convert in to a small letter if it's a small letter, it stays that way
    subb    $'a',    %cl    # because of the convertion - we check
    cmp     $'z'-'a',%cl
    ja      .L10
    xor     $0x20,  (%rdx)  # the xor on the specific bit swaps the letter from big to small or the opposite.
.L10:
    inc     %rdx            # gets the next char in the psring
    inc     %rax
    cmp     %rsi,   %rax
    jb     .L9
    xor     %rax,   %rax    #returns the pointer to the same psrting
    leaq    (%rdi), %rax
    ret

#Pstring* pstrijcpy(rdi - Pstring* dst, rsi - Pstring* src,rdx - char i, rcx - char j);
pstrijcpy: # the function copies the sub-pstring [i,j] from the second pstring to the first
    movzbq  %dl,   %r8     # checks if i is valid
    cmpb    $0,     %r8b
    jb      .L8
    movzbq  (%rdi), %r8    # puts length of array in r8
    dec     %r8
    cmp     %rcx,   %r8    # check's validity of the j
    jb      .L8
    movzbq  (%rsi), %r9    # puts length of array in r9
    dec     %r9
    cmp     %rcx,   %r9    # checks validity of the j
    jb      .L8
    leaq    1(%rdi, %rdx),%r10  # goes to i place in the first array
    leaq    1(%rsi, %rdx),%r11  # goes to i place in the second array
.L7:
    movzbq   (%r11), %rbx       #copies the char from the first array to the second
    movb    %bl, (%r10)
    inc     %r10                # i++
    inc     %r11
    inc     %rdx
    cmp     %rcx, %rdx          # end of for (i<=j)
    jbe      .L7
    movq    %rdi, %rax          #return dest pstring
    ret

.L8:
    pushq	%rbp		    # save the old frame pointer
    movq	%rsp,	%rbp	# create the new frame pointer
    pushq   %rdi            # save the pstring for later use
    pushq   %rsi

    movq	$str,%rdi	    # the string is the only paramter passed to the printf function.
    movq	$0,%rax
    call	printf		    # calling to printf.

    #return from printf:
    popq    %rsi
    popq    %rdi
    movq    %rdi, %rax 	    # return the first pstring
    movq	%rbp, %rsp	    # restore the old stack pointer - release all used memory.
    popq	%rbp		    # restore old frame pointer (the caller function frame)
    ret

#int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j);
pstrijcmp: # the function compares the sub-pstrings [i,j] in the 2 pstrings
    movzbq  %dl,   %r8     # checks if i is valid
    cmpb    $0,    %r8b
    jb      .L6
    movzbq  (%rdi), %r8    # puts length of array in r8
    dec     %r8
    cmp     %rcx,   %r8    # check's validity of the j
    jb      .L6
    movzbq  (%rsi), %r9    # puts length of array in r9
    dec     %r9
    cmp     %rcx,   %r9    # checks validity of the j
    jb      .L6
    leaq    1(%rdi, %rdx),%r10  # goes to i place in the first array
    leaq    1(%rsi, %rdx),%r11  # goes to i place in the second array
.L5:
    movzbq  (%r11), %rdi    #copies the char from the first array to the second
    movzbq  (%r10), %rsi
    sub     %rdi, %rsi
    jg      .L4             # if the first if bigger then the second
    jl      .L3             # if the second if bigger then the first
    inc     %r10            # i++
    inc     %r11
    inc     %rdx
    cmp     %rcx, %rdx      # end of for (i<=j)
    jbe      .L5
    movq    $0, %rax        #return dest pstring
    ret
.L4:
    movq    $1, %rax        #return dest pstring
    ret
.L3:
    movq    $-1, %rax       #return dest pstring
    ret

.L6:
    pushq	%rbp		    #save the old frame pointer
    movq	%rsp,	%rbp	#create the new frame pointer

    movq	$str,%rdi	    #the string is the only paramter passed to the printf function.
    movq	$0,%rax
    call	printf		    #calling to printf.

    #return from printf:
    movq	$-2, %rax	    #return the second pstring
    movq	%rbp, %rsp	    #restore the old stack pointer - release all used memory.
    popq	%rbp		    #restore old frame pointer (the caller function frame)
    ret