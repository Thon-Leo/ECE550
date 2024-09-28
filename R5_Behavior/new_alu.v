module new_alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

	// ------------------------- I/O ---------------------------
	input wire [31:0] data_operandA, data_operandB;
	input wire [ 4:0] ctrl_ALUopcode, ctrl_shiftamt;

	output reg [31:0] data_result;
	output reg isNotEqual, isLessThan, overflow;
	// ----------------------- end I/O -------------------------

	wire A_sign, B_sign, S_sign;
	wire signed [31:0] A_signed, B_signed;
	
	assign A_sign = data_operandA[31];
	assign B_sign = data_operandB[31];
	assign S_sign = data_result  [31];
	assign A_signed = data_operandA;
	assign B_signed = data_operandB;
	
	// -------------------- Assign Output -------------------
	always @(*) begin
	
		data_result = 32'b0;
		overflow    = 1'b0;
		
		case (ctrl_ALUopcode)
			5'b00000:begin
				data_result = data_operandA      +     data_operandB;
				overflow    = (A_sign == B_sign) & (A_sign != S_sign);
			end
			5'b00001:begin 
				data_result = data_operandA      -     data_operandB;
				overflow    = (A_sign != B_sign) & (A_sign != S_sign);
			end
			5'b00010:begin
				data_result = data_operandA      &     data_operandB;
			end
			5'b00011:begin
				data_result = data_operandA      |     data_operandB;
			end
			5'b00100:begin
				data_result = data_operandA     <<     ctrl_shiftamt;
			end
			5'b00101:begin
				data_result = data_operandA     >>>    ctrl_shiftamt;
			end
			default: begin
				
			end
		endcase 
	
		isNotEqual = A_signed !== B_signed;
		isLessThan = A_signed <   B_signed;
	end
	

endmodule
