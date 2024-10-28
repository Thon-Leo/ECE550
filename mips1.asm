        .data                   # Data segment
result: .word 0                 # Reserve a word in memory to store the result

        .text                   # Code segment
        .globl main             # Main label for the program

main:
        # Initialize values
        li $t0, 5               # Load immediate value 5 into register $t0
        li $t1, 10              # Load immediate value 10 into register $t1

        # Perform addition
        add $t2, $t0, $t1       # Add $t0 and $t1, store result in $t2

        # Store result in memory
        sw $t2, result          # Store word from $t2 into memory location result

        # Infinite loop to end program
loop:
        j loop                  # Jump to loop to keep program running
