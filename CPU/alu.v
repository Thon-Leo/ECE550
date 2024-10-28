//module alu(rst, data_operandA, data_operandB, ctrl_ALUopcode,
//			ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
//
//	input [31:0] data_operandA, data_operandB;
//	input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
//	output [31:0] data_result;
//	output isNotEqual, isLessThan, overflow;
//	
//	wire signed[31:0] inner_A, inner_B;
//	reg signed[31:0] inner_result;
//	reg inner_cout;
//	
//	assign inner_A = data_operandA;
//	assign inner_B = data_operandB;
//	assign data_result = inner_result;
//	
//	
//	assign isNotEqual = inner_A != inner_B;
//	assign isLessThan = inner_A < inner_B;
//	assign overflow = inner_cout != inner_result[31];
//	
//	always @(ctrl_ALUopcode or inner_A or inner_B or ctrl_shiftamt)
//		begin
//			// Default state for other ctrl_ALUopcode states
//			{inner_cout, inner_result} = inner_A + inner_B;
//			case (ctrl_ALUopcode)
//				0 : {inner_cout, inner_result} = inner_A + inner_B;  // ADD
//				1 : {inner_cout, inner_result} = inner_A - inner_B;	// SUBTRACT
//				2 : inner_result = inner_A & inner_B;  			// AND
//				3 : inner_result = inner_A | inner_B;  			// OR
//				4 : inner_result = inner_A << ctrl_shiftamt;		// SLL
//				5 : inner_result = inner_A >>> ctrl_shiftamt;	// SRA
//			endcase
//		end
//	
//endmodule
module alu(
    input rst,
    input [31:0] data_operandA, data_operandB,
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt,
    output reg [31:0] data_result,
    output reg isNotEqual, isLessThan, overflow
);

    wire signed [31:0] inner_A, inner_B;
    reg signed [31:0] inner_result;
    reg inner_cout;
    
    assign inner_A = data_operandA;
    assign inner_B = data_operandB;

    // Update outputs to zero when rst is 0
    always @(*) begin
        if (rst == 1) begin
            // Reset all outputs to zero
            data_result = 0;
            isNotEqual = 0;
            isLessThan = 0;
            overflow = 0;
        end else begin
            // Default state for addition when rst is 1
            {inner_cout, inner_result} = inner_A + inner_B;
            case (ctrl_ALUopcode)
                0 : {inner_cout, inner_result} = inner_A + inner_B;  // ADD
                1 : {inner_cout, inner_result} = inner_A - inner_B;  // SUBTRACT
                2 : inner_result = inner_A & inner_B;                // AND
                3 : inner_result = inner_A | inner_B;                // OR
                4 : inner_result = inner_A << ctrl_shiftamt;         // SLL
                5 : inner_result = inner_A >>> ctrl_shiftamt;        // SRA
                default : inner_result = 0;                          // Default case
            endcase

            // Assign data_result and flags based on the inner_result
            data_result = inner_result;
            isNotEqual = (inner_A != inner_B);
            isLessThan = (inner_A < inner_B);
            overflow = (inner_cout != inner_result[31]);
        end
    end

endmodule
