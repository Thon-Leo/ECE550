module counter (clk, rst, w, out, state_out);
	input wire w;
	input wire clk;
	input wire rst;
	output reg out;
	output wire [2:0] state_out;
	
	localparam [2:0]
		S0 = 3'b000,
		S1 = 3'b001,
		S2 = 3'b010,
		S3 = 3'b011,
		S4 = 3'b100;
	
	reg [2:0] state, next_state;
	
	// Output logic based on the current state (Moore)
	always @(state) begin
		case(state)
			S4: begin
				out = 1'b1;   // Output 1 when state is S4
			end
			default: begin
				out = 1'b0; // Output 0 for all other states
			end
		endcase
	end

	// State transition logic (sequential)
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			state <= S0;
		end
		else begin
			state <= next_state;
		end
	end

	// Next state logic (combinational)
	always @(*) begin
	
		case(state)
			S0: begin
			if (w == 1'b1) begin
				next_state = S1;
			end
			end
			S1: begin
				if (w == 1'b1) begin
				next_state = S2;
			end
		
			end
			S2: begin
				if (w == 1'b1) begin
				next_state = S3;
			end
			end
			S3: begin
				if (w == 1'b1) begin
				next_state = S4;
			end
			end
			S4: begin
				if (w == 1'b1) begin
				next_state = S0;
			end
			end
			default: begin
				next_state = state;
			end
		endcase
	end
	
	assign state_out = state;
	
endmodule 
