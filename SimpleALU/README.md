# PC 2

## Author
- **Name**: Yanbo Wang
- **NetID**: yw702

## Design Implementation
### Overview
This project implements an Arithmetic Logic Unit (ALU) in Verilog. In PC1, the ALU supported only addition and subtraction with overflow detection using a 32-bit Carry Select Adder (CSA). In PC2, additional features were added, including Shift Left Logical (SLL), Shift Right Arithmetic (SRA), and the inclusion of new comparison signals for not equal (ne) and less than (lt). The design follows a modular approach where each arithmetic component is broken down into submodules.

### Modules
- **alu.v**: The main ALU module that orchestrates operations based on control signals. It connects the different arithmetic and logic units to handle input operations.
- **csa.v**: Implements a CSA using 16-bit Carry Ripple Adder (RCA). This module is used to speed up addition by reducing carry propagation delays.
- **rca_16.v**: A 16-bit RCA that is used to perform multi-bit addition. This adder propagates carry bits sequentially across the bits of the operands.
- **fa.v**: A Full Adder module that forms the core of the addition operation. It handles the basic logic for adding two binary digits along with a carry bit.
- **SLL.v**: Implements the Shift Left Logical (SLL) operation, shifting bits left by a given number of positions.
- **SRA.v**: Implements the Shift Right Arithmetic (SRA) operation, shifting bits right while preserving the sign bit for signed numbers.
- **zero_check.v**: A helper module that checks if a given operand is zero, used in conjunction with comparison operations.
  
### New Features
- **Shift Left Logical (SLL)**: This operation shifts the bits of a given operand to the left by a specified amount, filling the rightmost bits with zero. The Shift Left Logical (SLL) operation is implemented in 5 stages, where each stage is controlled by a bit in the shamt (shift amount) input. Each stage checks a different bit of shamt and shifts the input value accordingly.

    In the first stage, if shamt[4] is 1, the input value is shifted left by 16 bits, otherwise no shift happens. In the second stage, if shamt[3] is 1, the result from the first stage is shifted left by 8 bits, or it stays the same. The third stage checks shamt[2], and if it is 1, the value from the second stage is shifted by 4 bits. The fourth stage is controlled by shamt[1], shifting the value from the third stage by 2 bits if the bit is set to 1. Finally, in the fifth stage, if shamt[0] is 1, the result from the fourth stage is shifted left by 1 bit, or it remains unchanged.

    The output of the SLL operation is the result of these sequential shifts, where each stage progressively shifts the value based on the corresponding bit in the shamt.

- **Shift Right Arithmetic (SRA)**: This operation shifts the bits of a given operand to the right by a specified amount, filling the leftmost bits with the MSB of the input. The only difference between SRA and SLL is in stage [1], where if the MSB of shamt is 1, we do the shift and fill the empty bits with the MSB of the input, instead of zeros.
- **Comparison Signals (ne and lt)**: Added signals for not equal (ne) and less than (lt) operations for comparing operands. These signals are correct only after a subtraction. The result of subtraction's sign XOR with overflow will give the less than signal, and equal was done by checking if all pairs of bits were 0 using NOR gates. Not equal then is the NOT of equal.

### Dependency
The dependency or hierarchy of the design is:
- ALU -> CSA -> 16-bit RCA -> FA
- ALU -> SLL
- ALU -> SRA
- IsNotEqual -> Zero-check

### Operation Control
- The opcode[0] is used to determine whether the operation is addition / subtraction, and / or, SLL / SRA. The opcode[1] is used for arithmitic / logic operations, and opcode[2] was used for choosing shifts / non-shifts.

## Bugs and Issues
Currently, there are no known functional bugs in the ALU design. 
