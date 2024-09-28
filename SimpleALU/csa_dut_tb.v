`timescale 1 ns / 100 ps

module csa_dut_tb ();

	// Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg Cin;

    // Outputs
    wire [31:0] Sum;
    wire Cout;
	 
	 csa dut (
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
	 task do_add(input [31:0] A_in, input [31:0] B_in, input Cin_in);
        begin
            A = A_in;
            B = B_in;
            Cin = Cin_in;
            @(negedge clk);  
            $display("A = %d, B = %d, Cin = %b", A, B, Cin);
				$display("My model outputs: Sum = %d, Cout = %b", Sum, Cout);
				$display("Where the answer should be: ", A + B + Cin_in);
            @(negedge clk);  // Wait for another clock cycle before de-assigning
            A = 32'hx;
            B = 32'hx;
        end
    endtask
	 
	 // Task to perform addition and compare results
    task do_random_test;
        reg [32:0] expected_sum;  // 33-bit register to capture expected sum with carry
        reg [32:0] calculated_sum;
        integer i;

        begin
            for (i = 0; i < 1000; i = i + 1) begin
                // Generate random values for A, B, and Cin
                A = $random;
                B = $random;
                Cin = $random % 2;  // Random 0 or 1 for Cin

                // Wait for the next clock edge
                @(negedge clk);

                // Calculate the expected sum and carry (33-bit to hold full result including carry)
                expected_sum = A + B + Cin;
                calculated_sum = {Cout, Sum};  // Concatenate Cout and Sum to get the full 33-bit result

                // Compare expected and actual result
                if (calculated_sum !== expected_sum) begin
                    $display("Error at iteration %0d:", i);
                    $display("A = %0d, B = %0d, Cin = %0b", A, B, Cin);
                    $display("Expected Sum = %0d, Expected Cout = %0b", expected_sum[31:0], expected_sum[32]);
                    $display("Actual Sum = %0d, Actual Cout = %0b", Sum, Cout);
						  #10;
						  $finish;
                end
                else begin
                    $display("Iteration %0d: PASS", i);
                end
            end
        end
    endtask
	 
	 
	 initial begin
        // Initialize inputs
        A = 32'b0;
        B = 32'b0;
        Cin = 1'b0;

        // Delay for some time and then start the random test
        #10;
        do_random_test();  // Perform the random test

        // End the simulation
        #10;
		  $display("you are good to go!");
		  #10;
        $finish;
    end
	 
//	 initial begin
//        // Initial values
//        A = 32'b0;
//        B = 32'b0;
//        Cin = 1'b0;
//
//        // Test cases
//        #10;
//        do_add(32'd5, 32'd10, 1'b0);  // Add 5 + 10 with Cin = 0
//        #10;
//        do_add(32'h7FFFFFFF, 32'd1, 1'b0);  // Add 65535 + 1 (overflow)
//        #10;
//        do_add(32'd1234, 32'd5678, 1'b1);  // Add 1234 + 5678 with Cin = 1
//        #10;
//        do_add(32'hFFFFFFFF, 32'h0001, 1'b0);  // Add 0xFFFF + 0x0001
//
//        // End the simulation
//        #10;
//        $finish;
//    end
	 
endmodule
