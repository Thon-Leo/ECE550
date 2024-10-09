
# Register File and Shift Operations in Verilog

## Author
- **Name**: Yanbo Wang
- **NetID**: yw702

## Design Implementation
This project contains several Verilog modules implementing basic operations for a register file. The main components include a register file with read and write capabilities consists of individual registers with enable and clear signals.

### Modules

#### dffe.v
The `dffe.v` module implements a D flip-flop with enable and clear signals:
- It was provided.

#### register.v
The `register.v` module implements a 32-bit register with the following features:
- Accepts a 32-bit input, this is done by generating 32 DFFEs.
- Includes enable (`en`) and clear (`clr`) signals for controlling the data stored in the register.
- All 32 DFFEs will use the same clock(`clock`), enbale(`en`), and clear (`clr`) signals. And each of them will store one bit of the input.

- The output is updated on the clock's rising edge, if the enable signal is high.

#### regfile.v
The `regfile.v` module implements a register file with the following features:
- Contains 32 32-bit registers.
- Allows reading from two registers and writing to one register in a single clock cycle.
- Use a decoder to select which register's enable should be high.


#### SLL.v
The `SLL.v` module implements a Shift Left Logical (SLL) operation:
- This file was copied from Simple_ALU project.
- The shifter is used like a decoder for enabling the write signal of the register file.



### How to Use
- To use the modules in a design, instantiate them within a top-level Verilog file.
- Provide appropriate clock, enable, and clear signals where needed.
- For the `SLL` module, provide the input value to be shifted and the desired shift amount.

### Bugs
- Currently there are no known issues.