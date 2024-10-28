nop

addi $1, $0, 65535      # r1 = 65535 = 0x0000FFFF
sll $2, $1, 15			# r2 = r1 << 15 = 0x7FFF8000 = 2147450880(decimal)
or $3, $2, $1		    # r3 = r2 + 32767 = 0x7FFF8000 + 0x00007FFF = 0x7FFFFFFF(hex) = 2147483647(decimal)
addi $4, $3, 1			# r4 = 1

