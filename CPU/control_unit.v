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
	alu_sel_op,
	is_add_i_sub
);

//	input wire processor_clock, regfile_clock;
	input wire [4:0] opcode, alu_op;
	
	output wire mem_to_reg, mem_write, ALU_src, reg_write, reg_rs2, is_add_i_sub;
	output wire [4:0] alu_sel_op;
	
	wire A, B, C, D, E;
	wire is_itype;
	
	// assign opcode to wires
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
	assign is_itype = (~A & ~B & C & ~D & E) | (~A & ~B & C & D & E) | (~A & B & ~C & ~D & ~E); // check is I type or not
	assign alu_sel_op = is_itype ? 5'b00000 : alu_op; // always perform add for I type then other for R type
	
	// check if we are doing a add, addi, or sub.
	wire is_add, is_addi, is_sub;
	assign is_add = (~A & ~B & ~C & ~D & ~E) & (~alu_op[4] & ~alu_op[3] & ~alu_op[2] & ~alu_op[1] & ~alu_op[0]);
	assign is_addi = (~A & ~B & C & ~D & E);
	assign is_sub = (~A & ~B & ~C & ~D & ~E) & (~alu_op[4] & ~alu_op[3] & ~alu_op[2] & ~alu_op[1] & alu_op[0]);
	assign is_add_i_sub = is_add | is_addi | is_sub;
	
endmodule
