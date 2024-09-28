`timescale 1 ns / 100 ps

module tb ();

	 // Inputs
	reg clk, rst;
	wire [2:0] state_out;
	// Outputs
	wire out;

	// Instantiate the counter module
	counter dut (
		.clk(clk),
		.rst(rst),
		.w(1'b1),
		.out(out),
		.state_out(state_out)
	);

	// Clock generation
	initial begin
		clk = 0;
		forever #5 clk = ~clk; // Toggle the clock every 5ns (100MHz clock)
	end

	// Test stimulus
	initial begin
		// reset dut
		rst = 1'b1;
		#10 rst = 1'b0;
		
		// Monitor the output and state transitions
		$monitor("Time = %d ns, Clock = %b, Output = %b, State = %b", $time, clk, out, state_out);

		// Run the simulation for a sufficient time to observe the output
		#120 $stop;  // Stop the simulation after 100ns
	end
 
endmodule
