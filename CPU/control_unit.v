module control_unit(
//	processor_clock, 
//	regfile_clock,
	opcode,
	alu_op,
	mem_to_reg,
	mem_write,
	ALU_src,
	reg_write,
	reg_rs2,
	alu_sel_op
);

//	input wire processor_clock, regfile_clock;
	input wire [4:0] opcode, alu_op;
	
	output wire mem_to_reg, mem_write, ALU_src, reg_write, reg_rs2;
	output wire [4:0] alu_sel_op;
	
	wire A, B, C, D, E;
	
	assign A = opcode[4];
	assign B = opcode[3];
	assign C = opcode[2];
	assign D = opcode[1];
	assign E = opcode[0];

	assign mem_to_reg = B; // The input to Reg: 0: ALU 1: Mem
	assign mem_write  = C & D & E; // 0: dont write mem, 1: write mem
	assign ALU_src    = ~A & ~B & ~C & ~D & ~E; // 1: Reg 0: imm
	assign reg_write  = (~A & ~C & ~D & ~E) | (~B & C & ~D & E) | (~A & ~B & ~C & D & E); // 
	assign reg_rs2    = C & D & E; // 1: rd 0: rs2
	assign alu_sel_op = (~A & ~B & C & ~D & E) ? 5'b00000 : alu_op;
	
endmodule
