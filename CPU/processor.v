	/**
	* READ THIS DESCRIPTION!
	*
	* The processor takes in several inputs from a skeleton file.
	*
	* Inputs
	* clock: this is the clock for your processor at 50 MHz
	* reset: we should be able to assert a reset to start your pc from 0 (sync or
	* async is fine)
	*
	* Imem: input data from imem
	* Dmem: input data from dmem
	* Regfile: input data from regfile
	*
	* Outputs
	* Imem: output control signals to interface with imem
	* Dmem: output control signals and data to interface with dmem
	* Regfile: output control signals and data to interface with regfile
	*
	* Notes
	*
	* Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
	* testbench can see which controls signal you active when. Therefore, there needs to be a way to
	* "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
	* file acts as a small wrapper around your processor for this purpose.
	*
	* You will need to figure out how to instantiate two memory elements, called
	* "syncram," in Quartus: one for imem and one for dmem. Each should take in a
	* 12-bit address and allow for storing a 32-bit value at each address. Each
	* should have a single clock.
	*
	* Each memory element should have a corresponding .mif file that initializes
	* the memory element to certain value on start up. These should be named
	* imem.mif and dmem.mif respectively.
	*
	* Importantly, these .mif files should be placed at the top level, i.e. there
	* should be an imem.mif and a dmem.mif at the same level as process.v. You
	* should figure out how to point your generated imem.v and dmem.v files at
	* these MIF files.
	*
	* imem
	* Inputs:  12-bit address, 1-bit clock enable, and a clock
	* Outputs: 32-bit instruction
	*
	* dmem
	* Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
	* Outputs: 32-bit data at the given address
	*
	*/
	module processor(
	// Control signals
	clock,                          // I: The master clock
	reset,                          // I: A reset signal

	// Imem
	address_imem,                   // O: The address of the data to get from imem
	q_imem,                         // I: The data from imem

	// Dmem
	address_dmem,                   // O: The address of the data to get or put from/to dmem
	data,                           // O: The data to write to dmem
	wren,                           // O: Write enable for dmem
	q_dmem,                         // I: The data from dmem

	// Regfile
	ctrl_writeEnable,               // O: Write enable for regfile
	ctrl_writeReg,                  // O: Register to write to in regfile
	ctrl_readRegA,                  // O: Register to read from port A of regfile
	ctrl_readRegB,                  // O: Register to read from port B of regfile
	data_writeReg,                  // O: Data to write to for regfile
	data_readRegA,                  // I: Data from port A of regfile
	data_readRegB                   // I: Data from port B of regfile
	);
	// Control signals
	input clock, reset;

	// Imem
	output wire [11:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [11:0] address_dmem;
	output [31:0] data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;
	
	// control unit sigs
	wire mem_to_reg, mem_write, ALU_src, reg_write, reg_rs2;
	
	// ALU_sigs
	wire [31:0] data_operandA, data_operandB, data_result;
	wire [4:0] ctrl_ALUopcode;
	wire [4:0] ctrl_shiftamt;
	wire isNotEqual, isLessThan, overflow;
	
	// PC
	wire [11:0] PC_next;
	
	register pc(
		.clk	(clock),
		.clr	(reset),
		.d		(PC_next),
		.en	(1'b1),
		.q		(address_imem)
	);
	
	rca_12 pc_adder(
		.A		(address_imem), 
		.B		(12'b1),   
		.Cin	(1'b0),           
		.Sum	(PC_next),   
		.Cout	()       
	);
//	assign PC_next = address_imem + 1;
	
	// control unit
	control_unit c_i(
		//		.processor_clock, 
		//		.regfile_clock,
		.opcode		(q_imem[31:27]),
		.alu_op		(q_imem[6:2]),
		.mem_to_reg (mem_to_reg),
		.mem_write	(mem_write),
		.ALU_src		(ALU_src),
		.reg_write	(reg_write),
		.reg_rs2		(reg_rs2),
		.alu_sel_op (ctrl_ALUopcode)
	);
	
	// regfile output
	// ctrl_writeReg, ctrl_writeEnabl, ctrl_readRegA, ctrlreadRegB
	assign ctrl_writeEnable = reg_write;
	assign ctrl_writeReg = (overflow) ? 5'b11110 : q_imem[26:22];
	assign ctrl_readRegB = (reg_rs2) ? q_imem[26:22] : q_imem[16:12];
	assign ctrl_readRegA = q_imem[21:17];
	
	// overflow data
	wire [31:0] status_data;
	assign status_data = (~q_imem[31] & ~q_imem[30] & q_imem[29] & ~q_imem[28] & q_imem[27]) ? 32'h00000002 : (q_imem[2]) ? 32'h00000003 : 32'h00000001;
	assign data_writeReg = (overflow) ? status_data : (mem_to_reg) ? q_dmem : data_result;
	
	
	// alu input
	assign data_operandA = data_readRegA;
	assign data_operandB = (ALU_src) ? data_readRegB : {{16{q_imem[16]}}, q_imem[15:0]};

	assign ctrl_shiftamt = q_imem[11:7];
	

	// ALU
	alu alu_i(
		.rst(reset),
		.data_operandA	(data_operandA), 
		.data_operandB	(data_operandB), 
		.ctrl_ALUopcode(ctrl_ALUopcode),
		.ctrl_shiftamt	(ctrl_shiftamt), 
		.data_result	(data_result), 
		.isNotEqual		(isNotEqual), 
		.isLessThan		(isLessThan), 
		.overflow		(overflow)
	);
	
	// Mem
	assign data 			= data_readRegB;
	assign address_dmem	= data_result;
	assign wren 			= mem_write;
 

endmodule
