  module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

// ------------------------- I/O ---------------------------
   input wire [31:0] data_operandA, data_operandB;
   input wire [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output wire [31:0] data_result;
   output wire isNotEqual, isLessThan, overflow;
// ----------------------- end I/O -------------------------
   
// ---------------- Local Var Declareration ----------------
	wire [31:0] B_in, B_not;
	wire [31:0] add_sub_result, comp_result, not_comp; 	// Adders
	wire [31:0] and_result, or_result; 			// Logics
	wire [31:0] sll_result, sra_result; 		// shifts
	wire [31:0] and_or_result, shift_result;	// mux level 1
	wire [31:0] logic_arith_result; 				// and or / arith result
	wire Cout, equal;
	// -------- OVF Sigs ---------
	wire same_sign_AB, diff_sign_AS; // for addition
	wire diff_sign_AB, same_sign_AS; // for subtraction
	wire ovf_add, ovf_sub;
	
// -------------------- Assign Local Var -------------------
	genvar i;
	generate
		 for (i = 0; i < 32; i = i + 1) begin : not_gen
			  not (B_not[i]   , data_operandB[i]);  // Invert each bit of data_operandB
			  not (not_comp[i], comp_result[i]);
		 end
	endgenerate
	
	assign B_in = (ctrl_ALUopcode[0]) ? B_not : data_operandB; // 1 for sub
	
	// -------- AND and OR Gates ---------
	generate
		for (i = 0; i < 32; i = i + 1) begin : and_or_gen
			and (and_result[i], data_operandA[i], data_operandB[i]); // AND operation
			or  (or_result[i],  data_operandA[i], data_operandB[i]);  // OR operation
		end
	endgenerate

	// -------- OVF Detection ---------
	xnor (same_sign_AB, data_operandA[31], data_operandB[31]);  // if AB have the same sign
	xor  (diff_sign_AS, data_operandA[31], add_sub_result[31]); // if A and sum have the same sign
	and  (ovf_add,      same_sign_AB, 	   diff_sign_AS); // if AB have the same sign but different with the sum's
	
	not  (diff_sign_AB, same_sign_AB);  
	and  (ovf_sub,      diff_sign_AB, 	   diff_sign_AS); // if AB have the same sign but different with the sum's
	assign overflow = (ctrl_ALUopcode[0]) ? ovf_sub : ovf_add;

// ---------------------- Instantiation -------------------------	
	csa csa_i(
		.A(data_operandA),
		.B(B_in),
		.Cin(ctrl_ALUopcode[0]),
		.Sum(add_sub_result),
		.Cout(Cout)
	);
	
	csa csa_comp(
		.A(data_operandA),
		.B(B_not),
		.Cin(1'b1),
		.Sum(comp_result),
		.Cout(Cout)
	);
	
	SLL sll_i(
		.a(data_operandA),
		.shamt(ctrl_shiftamt),
		.y(sll_result)
	);
	
	SRA sra_i(
		.a(data_operandA),
		.shamt(ctrl_shiftamt),
		.y(sra_result)
	);
	
	zero_check z_i(
		.num(comp_result),
		.isZero(equal)
	);
// ----------------------- assign output --------------------	
	assign and_or_result 		= (ctrl_ALUopcode[0]) ? or_result    : and_result;
	assign shift_result	 		= (ctrl_ALUopcode[0]) ? sra_result   : sll_result;
	assign logic_arith_result  = (ctrl_ALUopcode[1]) ? and_or_result: add_sub_result;
	assign data_result   		= (ctrl_ALUopcode[2]) ? shift_result : logic_arith_result;
	
	not (isNotEqual, equal);
	assign isLessThan = (ovf_sub) ? not_comp[31] : comp_result[31];

endmodule
