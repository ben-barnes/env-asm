        ## PROGRAM: env
        ## 
        ## PURPOSE: To demonstrate how environment variables are passed to a
        ##          process.
        ## 
        ## Assuming you set %rbp = %rsp at program start, then the stack appears
        ## as follows:
        ## 
        ## [  0x00000000  ] %rbp + 8(n + m + 3)
        ## 
        ## [  env[m]      ] %rbp + 8(n + m + 3)
        ## [  ...         ]
        ## [  env[1]      ] %rbp + 8(n + 4)
        ## [  env[0]      ] %rbp + 8(n + 3)
        ## [  0x00000000  ] %rbp + 8(n + 2)
        ## [  argv[n]     ] %rbp + 8(n + 1)
        ## [  ...         ] 
        ## [  argv[1]     ] %rbp + 16
        ## [  argv[0]     ] %rbp +  8 (program name)
        ## [  argc        ] %rbp +  0
        ## 
        ## Remembering that the arguments on the stack are in reverse order,
        ## they are:
        ## 
        ## argc       : Argument count.
        ## argv[]     : Argument array. One pointer per argument.
        ## 0x00000000 : Zero, separates arguments from environment variables.
        ## env[]      : Environment variable array. One pointer per variable.
        ## 0x00000000 : Zero, terminates environment variable array.

        .equ SYS_EXIT, 60
        .equ EXIT_SUCCESS, 0

        .section .data
format_str:
        .ascii "%s\n\0"

        .section .text
        .globl _start
_start:
        mov %rsp, %rbp

        ## Set stdout to line buffering.
        mov stdout, %rdi
        call setlinebuf
        
        ## Grab argc so we know how many arguments to skip.
        mov (%rbp), %rbx

        ## Skip over the last argument and zero separator.
        add $2, %rbx

print_env_loop: 
        ## Get the address of the next argument.
        ## We're going straight to rsi as that's where printf expects it.
        mov (%rbp,%rbx,8), %rsi

        ## Check for the null pointer which terminates the argument list.
        cmp $0, %rsi
        je exit_success

        ## Print the argument.
        mov $format_str, %rdi
        call printf

        ## Move to the next argument and repeat.
        inc %rbx
        jmp print_env_loop

exit_success:
        mov $SYS_EXIT, %rax
        mov $EXIT_SUCCESS, %rdi
        syscall
        
