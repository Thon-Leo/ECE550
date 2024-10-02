module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

   // Internal variables
   wire [31:0] registers [31:0];  // 32 registers each holding 32 bits
   wire write_decoded [31:0];     // 1-hot write decoder output
	wire [31:0] write_enable;
	
   // Generate 32-to-1 Write Decoder using a shift left logic (SLL) module
   wire [31:0] write_enable_shifted;
   SLL write_decoder (
      .a(32'b00000000000000000000000000000001),   // Initial value for shift
      .shamt(ctrl_writeReg),                      // Shift by the value of ctrl_writeReg
      .y(write_enable_shifted)                    // Output the 1-hot encoding
   );

   // Write enable signal logic
   genvar i;
   generate
      for (i = 0; i < 32; i = i + 1) begin : regfile_loop
         // Write to the register only if the specific write enable bit is set and writeEnable is active
         and (write_enable[i], write_enable_shifted[i], ctrl_writeEnable);

         register reg_instance (
            .q(registers[i]), 
            .d(data_writeReg), 
            .clk(clock), 
            .en(write_enable), 
            .clr(ctrl_reset)
         );
      end
   endgenerate

   // Read Logic
   assign data_readRegA = registers[ctrl_readRegA];  // Read register A
   assign data_readRegB = registers[ctrl_readRegB];  // Read register B

endmodule
 
