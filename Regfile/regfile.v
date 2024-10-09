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
	wire [31:0] write_enable;
	
	wire az, bz;
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
            .en(write_enable[i]), 
            .clr(ctrl_reset)
         );
      end
   endgenerate
	
	// check if any is reading from reg 0
	zero_check z_a(
		.num({ctrl_readRegA}),
		.isZero(za)
	);
	zero_check z_b(
		.num({ctrl_readRegB}),
		.isZero(zb)
	);
	
   // Read Logic
   assign data_readRegA = (za) ? 32'b0 : registers[ctrl_readRegA];  // Read register A
   assign data_readRegB = (zb) ? 32'b0 : registers[ctrl_readRegB];  // Read register B

endmodule
 
