`timescale 1 ns / 100 ps

module rca_dut_tb ();

	// Inputs
    reg [15:0] A;
    reg [15:0] B;
    reg Cin;

    // Outputs
    wire [15:0] Sum;
    wire Cout;
	 
	 rca_16 dut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .Sum(Sum), 
        .Cout(Cout)
    );
	 
	 // clk
	 reg clk;
    initial clk = 1'b1;
    always #1 clk = ~clk;
	 
	 // task setup
	 task do_add(input [15:0] A_in, input [15:0] B_in, input Cin_in);
        begin
            A = A_in;
            B = B_in;
            Cin = Cin_in;
            @(negedge clk);  
            $display("A = %d, B = %d, Cin = %b", A, B, Cin);
				$display("My model outputs: Sum = %d, Cout = %b", Sum, Cout);
				$display("Where the answer should be: ", A + B + Cin_in);
            @(negedge clk);  // Wait for another clock cycle before de-assigning
            A = 16'hx;
            B = 16'hx;
        end
    endtask
	 
	 
	 initial begin
        // Initial values
        A = 16'b0;
        B = 16'b0;
        Cin = 1'b0;

        // Test cases
        #10;
        do_add(16'd5, 16'd10, 1'b0);  // Add 5 + 10 with Cin = 0
        #10;
        do_add(16'd65535, 16'd1, 1'b0);  // Add 65535 + 1 (overflow)
        #10;
        do_add(16'd1234, 16'd5678, 1'b1);  // Add 1234 + 5678 with Cin = 1
        #10;
        do_add(16'hFFFF, 16'h0001, 1'b0);  // Add 0xFFFF + 0x0001

        // End the simulation
        #10;
        $finish;
    end
	 
endmodule
