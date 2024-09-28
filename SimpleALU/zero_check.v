module zero_check (
	input [31:0] num,  // 32-bit input number
	output isZero      // Output: 1 if number is 0, 0 otherwise
);

	wire [15:0] first_stage;  // First stage of NOR gates (16 results)
	wire [7:0] second_stage;  // Second stage of NOR gates (8 results)
	wire [3:0] third_stage;   // Third stage of NOR gates (4 results)
	wire [1:0] fourth_stage;  // Fourth stage of NOR gates (2 results)

	// First stage: NOR each pair of bits
	genvar i;
	generate
		for (i = 0; i < 16; i = i + 1) begin : first_stage_gen
			nor (first_stage[i], num[2*i], num[2*i+1]);  // NOR adjacent pairs of bits
		end
	endgenerate

	// Second stage: NOR pairs of first stage results
	generate
		for (i = 0; i < 8; i = i + 1) begin : second_stage_gen
			nor (second_stage[i], first_stage[2*i], first_stage[2*i+1]);
		end
	endgenerate

	// Third stage: NOR pairs of second stage results
	generate
		for (i = 0; i < 4; i = i + 1) begin : third_stage_gen
			nor (third_stage[i], second_stage[2*i], second_stage[2*i+1]);
		end
	endgenerate

	// Fourth stage: NOR pairs of third stage results
	generate
		for (i = 0; i < 2; i = i + 1) begin : fourth_stage_gen
			nor (fourth_stage[i], third_stage[2*i], third_stage[2*i+1]);
		end
	endgenerate

	// Final stage: NOR the last two results
	nor (isZero, fourth_stage[0], fourth_stage[1]);

endmodule
