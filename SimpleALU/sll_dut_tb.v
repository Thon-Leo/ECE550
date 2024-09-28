`timescale 1 ns / 100 ps

module sll_dut_tb ();

    // Inputs
    reg [31:0] a;
	 reg [31:0] exp;
    reg [4:0] shamt;

    // Outputs
    wire [31:0] y;

    // Instantiate the SLL32 unit
    SLL dut (
        .a(a), 
        .shamt(shamt), 
        .y(y)
    );

    // Clock generation (although not strictly needed in a combinational circuit testbench)
    reg clk;
    initial clk = 1'b1;
    always #1 clk = ~clk;

    // Task to apply inputs and display results
    task do_shift(input [31:0] a_in, input [4:0] shamt_in);
        begin
            a <= a_in;
            shamt <= shamt_in;
				exp <= a_in << shamt_in;
            #2;
				@(negedge clk);
            $display("a = %b, shamt = %d", a, shamt);
            $display("Shifted output (y) = %b", y);
				if (y !== exp) begin
					$display("Error! Whereas we expect = %b", exp);
					#2;
					$stop;
				end
            @(negedge clk);
//            a <= 32'hx;
//            shamt <= 5'hx;
        end
    endtask

    // Initial block to start simulation
    initial begin
        // Initial values
        a <= 32'b0;
        shamt <= 5'b0;

        // Wait a bit before starting tests
        #10;

        // Test cases
        do_shift(32'h00000005, 5'd1);  // Shift 5 left by 1
        #10;
        do_shift(32'h0000000F, 5'd2);  // Shift 15 left by 2
        #10;
        do_shift(32'hFFFFFFFF, 5'd4);  // Shift all 1s left by 4
		  #10
		  do_shift(32'hFFFFFFFF, 5'd5);  // Shift all 1s left by 4
        #10;
        do_shift(32'hA5A5A5A5, 5'd8);  // Shift pattern left by 8
		  #10;
        do_shift(32'hA5A5A5A5, 5'd13);  // Shift pattern left by 8
        #10;
        do_shift(32'h12345678, 5'd16); // Shift 0x12345678 left by 16
		  #10;
        do_shift(32'h12345678, 5'd25); // Shift 0x12345678 left by 16
        #10;
        do_shift(32'h87654321, 5'd31); // Shift 0x87654321 left by 31
		  #2;
		  $display("Simulation success!");
        // End the simulation
        #10;
        $stop;
    end

endmodule
