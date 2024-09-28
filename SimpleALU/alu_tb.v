`timescale 1 ns / 100 ps

module alu_tb();

    // inputs to the ALU are reg type

    reg            clock;
    reg signed [31:0] data_operandA, data_operandB, data_expected;
    reg [4:0] ctrl_ALUopcode, ctrl_shiftamt;


    // outputs from the ALU are wire type
    wire [31:0] data_result;
    wire isNotEqual, isLessThan, overflow;


    // Tracking the number of errors
    integer errors;
    integer index;    // for testing...
	
//	 reg same_AB, diff_AS; 

    // Instantiate ALU
    alu alu_ut(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt,
        data_result, isNotEqual, isLessThan, overflow);

//    assign same_AB = alu_ut.same_sign_AB;
	 
	 initial

    begin
        $display($time, " << Starting the Simulation >>");
        clock = 1'b0;    // at time 0
        errors = 0;

        checkOr();
        checkAnd();
        checkAdd();
        checkSub();
        checkSLL();
        checkSRA();
//
        checkNE();
        checkLT();
        checkOverflow();
//			check_add_rand();
//			check_sub_rand();
//			check_sub_ovf_rand();
//			check_add_ovf_rand();
        if(errors == 0) begin
            $display("The simulation completed without errors");
        end
        else begin
            $display("The simulation failed with %d errors", errors);
        end

        $stop;
    end

    // Clock generator
    always
         #10     clock = ~clock;

    task checkOr;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00011;
            assign ctrl_shiftamt = 5'b00000;

            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(data_result !== 32'h00000000) begin
                $display("**Error in OR (test 1); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'hFFFFFFFF;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(data_result !== 32'hFFFFFFFF) begin
                $display("**Error in OR (test 2); expected: %h, actual: %h", 32'hFFFFFFFF, data_result);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'hFFFFFFFF;

            @(negedge clock);
            if(data_result !== 32'hFFFFFFFF) begin
                $display("**Error in OR (test 3); expected: %h, actual: %h", 32'hFFFFFFFF, data_result);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'hFFFFFFFF;
            assign data_operandB = 32'hFFFFFFFF;

            @(negedge clock);
            if(data_result !== 32'hFFFFFFFF) begin
                $display("**Error in OR (test 4); expected: %h, actual: %h", 32'hFFFFFFFF, data_result);
                errors = errors + 1;
            end
        end
    endtask

    task checkAnd;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00010;
            assign ctrl_shiftamt = 5'b00000;

            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(data_result !== 32'h00000000) begin
                $display("**Error in AND (test 5); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'hFFFFFFFF;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(data_result !== 32'h00000000) begin
                $display("**Error in AND (test 6); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'hFFFFFFFF;

            @(negedge clock);
            if(data_result !== 32'h00000000) begin
                $display("**Error in AND (test 7); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'hFFFFFFFF;
            assign data_operandB = 32'hFFFFFFFF;

            @(negedge clock);
            if(data_result !== 32'hFFFFFFFF) begin
                $display("**Error in AND (test 8); expected: %h, actual: %h", 32'hFFFFFFFF, data_result);
                errors = errors + 1;
            end
        end
    endtask

    task checkAdd;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00000;
            assign ctrl_shiftamt = 5'b00000;

            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(data_result !== 32'h00000000) begin
                $display("**Error in ADD (test 9); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end

            for(index = 0; index < 31; index = index + 1)
            begin
                @(negedge clock);
                assign data_operandA = 32'h00000001 << index;
                assign data_operandB = 32'h00000001 << index;

                assign data_expected = 32'h00000001 << (index + 1);

                @(negedge clock);
                if(data_result !== data_expected) begin
                    $display("**Error in ADD (test 17 part %d); expected: %h, actual: %h", index, data_expected, data_result);
                    errors = errors + 1;
                end
            end
        end
    endtask

    task checkSub;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00001;
            assign ctrl_shiftamt = 5'b00000;

            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(data_result !== 32'h00000000) begin
                $display("**Error in SUB (test 10); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end
        end
    endtask

    task checkSLL;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00100;
            assign data_operandB = 32'h00000000;

            assign data_operandA = 32'h00000001;
            assign ctrl_shiftamt = 5'b00000;

            @(negedge clock);
            if(data_result !== 32'h00000001) begin
                $display("**Error in SLL (test 11); expected: %h, actual: %h", 32'h00000001, data_result);
                errors = errors + 1;
            end

            for(index = 0; index < 5; index = index + 1)
            begin
                @(negedge clock);
                assign data_operandA = 32'h00000001;
                assign ctrl_shiftamt = 5'b00001 << index;

                assign data_expected = 32'h00000001 << (2**index);

                @(negedge clock);
                if(data_result !== data_expected) begin
                    $display("**Error in SLL (test 18 part %d); expected: %h, actual: %h", index, data_expected, data_result);
                    errors = errors + 1;
                end
            end

            for(index = 0; index < 4; index = index + 1)
            begin
                @(negedge clock);
                assign data_operandA = 32'h00000001;
                assign ctrl_shiftamt = 5'b00011 << index;

                assign data_expected = 32'h00000001 << ((2**index) + (2**(index + 1)));

                @(negedge clock);
                if(data_result !== data_expected) begin
                    $display("**Error in SLL (test 19 part %d); expected: %h, actual: %h", index, data_expected, data_result);
                    errors = errors + 1;
                end
            end
        end
    endtask

    task checkSRA;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00101;
            assign data_operandB = 32'h00000000;

            assign data_operandA = 32'h00000000;
            assign ctrl_shiftamt = 5'b00000;

            @(negedge clock);
            if(data_result !== 32'h00000000) begin
                $display("**Error in SRA (test 12); expected: %h, actual: %h", 32'h00000000, data_result);
                errors = errors + 1;
            end
        end
    endtask

    task checkNE;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00001;
            assign ctrl_shiftamt = 5'b00000;

            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(isNotEqual !== 1'b0) begin
                $display("**Error in isNotEqual (test 13); expected: %b, actual: %b", 1'b0, isNotEqual);
                errors = errors + 1;
            end
        end
    endtask

    task checkLT;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00001;
            assign ctrl_shiftamt = 5'b00000;

            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(isLessThan !== 1'b0) begin
                $display("**Error in isLessThan (test 14); expected: %b, actual: %b", 1'b0, isLessThan);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'h0FFFFFFF;
            assign data_operandB = 32'hFFFFFFFF;

            @(negedge clock);
            if(isLessThan !== 1'b0) begin
                $display("**Error in isLessThan (test 23); expected: %b, actual: %b", 1'b0, isLessThan);
                errors = errors + 1;
            end

            // Less than with overflow
            @(negedge clock);
            assign data_operandA = 32'h80000001;
            assign data_operandB = 32'h7FFFFFFF;

            @(negedge clock);
            if(isLessThan !== 1'b1) begin
                $display("**Error in isLessThan (test 24); expected: %b, actual: %b", 1'b1, isLessThan);
                errors = errors + 1;
            end
        end
    endtask

    task checkOverflow;
        begin
            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00000;
            assign ctrl_shiftamt = 5'b00000;

            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(overflow !== 1'b0) begin
                $display("**Error in overflow (test 15); expected: %b, actual: %b", 1'b0, overflow);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'h80000000;
            assign data_operandB = 32'h80000000;

            @(negedge clock);
            if(overflow !== 1'b1) begin
                $display("**Error in overflow (test 20); expected: %b, actual: %b", 1'b1, overflow);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'h40000000;
            assign data_operandB = 32'h40000000;

            @(negedge clock);
            if(overflow !== 1'b1) begin
                $display("**Error in overflow (test 21); expected: %b, actual: %b", 1'b1, overflow);
                errors = errors + 1;
            end

            @(negedge clock);
            assign ctrl_ALUopcode = 5'b00001;

            assign data_operandA = 32'h00000000;
            assign data_operandB = 32'h00000000;

            @(negedge clock);
            if(overflow !== 1'b0) begin
                $display("**Error in overflow (test 16); expected: %b, actual: %b", 1'b0, overflow);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'h80000000;
            assign data_operandB = 32'h80000000;

            @(negedge clock);
            if(overflow !== 1'b0) begin
                $display("**Error in overflow (test 22); expected: %b, actual: %b", 1'b0, overflow);
                errors = errors + 1;
            end

            @(negedge clock);
            assign data_operandA = 32'h80000000;
            assign data_operandB = 32'h0F000000;

            @(negedge clock);
            if(overflow !== 1'b1) begin
                $display("**Error in overflow (test 25); expected: %b, actual: %b", 1'b1, overflow);
                errors = errors + 1;
            end
        end
    endtask
	 
	 
	 task check_add_rand(); 
		reg [31:0] expected_sum;  // 33-bit register to capture expected sum with carry
		reg [31:0] calculated_sum;
		integer i;
		begin
			// init values
			@(negedge clock);
			ctrl_ALUopcode <= 5'b00000;  
			ctrl_shiftamt <= 5'b00000;   

			data_operandA <= 32'h00000001;  
			data_operandB <= 32'h00000000;
			
			// rand test
			@(negedge clock);
			for (i = 0; i < 1000; i = i + 1) begin
				 // Generate random values for A, B, and Cin
				 data_operandA <= $random;
				 data_operandB <= $random;

				 // Wait for the next clock edge
				 @(negedge clock);

				 // Calculate the expected sum and carry (33-bit to hold full result including carry)
				 expected_sum <= data_operandA + data_operandB;
				 calculated_sum <= data_result;  // Concatenate Cout and Sum to get the full 33-bit result

				 // Compare expected and actual result
				 if (calculated_sum !== expected_sum) begin
					  $display("Error at iteration %0d:", i);
					  $display("A = %0d, B = %0d", data_operandA, data_operandB);
					  $display("Expected Sum = %0d", expected_sum[31:0]);
					  $display("Actual Sum = %0d", calculated_sum);
					  #10;
					  $finish;
				 end
				 else begin
					  $display("A = %0d, B = %0d", data_operandA, data_operandB);
					  $display("Sum = %0d", expected_sum[31:0]);
					  $display("Iteration %0d: PASS", i);
				 end
			end
			#10;
			$display("add passed!");
		end
        
	 endtask
	 
	 task check_sub_rand(); 
		reg [31:0] expected_sum;  
		reg [31:0] calculated_sum;
		integer i;
		begin
			// init values
			@(negedge clock);
			ctrl_ALUopcode <= 5'b00001;  
			ctrl_shiftamt <= 5'b00000;   

			data_operandA <= 32'h00000001;  
			data_operandB <= 32'h00000000;
			
			// rand test
			@(negedge clock);
			for (i = 0; i < 1000; i = i + 1) begin
				 // Generate random values for A, B, and Cin
				 data_operandA <= $random;
				 data_operandB <= $random;

				 // Wait for the next clock edge
				 @(negedge clock);

				 // Calculate the expected sum and carry (33-bit to hold full result including carry)
				 expected_sum = data_operandA - data_operandB;
				 calculated_sum = data_result;  // Concatenate Cout and Sum to get the full 33-bit result

				 // Compare expected and actual result
				 if (calculated_sum !== expected_sum) begin
					  $display("Error at iteration %0d:", i);
					  $display("A = %0h, B = %0h", data_operandA, data_operandB);
					  $display("Expected Sum = %0h", expected_sum[31:0]);
					  $display("Actual Sum = %0h", calculated_sum);
					  #10;
					  $finish;
				 end
				 else begin
						$display("A = %0h, B = %0h", data_operandA, data_operandB);
					  $display("Sum = %0h", expected_sum[31:0]);
					  $display("Iteration %0d: PASS", i);
				 end
			end
			#10;
			$display("sub passed!");
		end
        
	 endtask
	 
	 task check_sub_ovf_rand(); 
		reg expected_ovf;  
		reg calculated_ovf;
		reg same_sign_AB, diff_sign_AS;
		integer i;
		begin
			// Init values
			@(negedge clock);
			ctrl_ALUopcode <= 5'b00001;  // Use non-blocking assignment
			ctrl_shiftamt <= 5'b00000;   // Use non-blocking assignment

			data_operandA <= 32'h00000000;  // Use non-blocking assignment
			data_operandB <= 32'h00000000;  // Use non-blocking assignment
			#10;

			// Random test loop
			@(negedge clock);
			for (i = 0; i < 1000; i = i + 1) begin
				// Generate random values for A and B
				data_operandA <= $random;  // Procedural assignment to assign new values
				data_operandB <= $random;  // Procedural assignment to assign new values

				// Wait for the next clock edge
				@(negedge clock);

				// Compute expected overflow
				same_sign_AB = !(data_operandA[31] ^ !data_operandB[31]);  // Check if A and B have the same sign
				diff_sign_AS = (data_operandA[31] ^ data_result[31]);     // Check if A and the result have different signs
				expected_ovf = (same_sign_AB & diff_sign_AS);  // Overflow condition

				// Capture actual overflow
				calculated_ovf = overflow;

				// Compare expected and actual result
				if (expected_ovf !== calculated_ovf) begin
					 $display("Error at iteration %0d:", i);
					 $display("A = %0d, B = %0d", data_operandA, data_operandB);
					 $display("Result = %0d", data_result);
					 $display("Expected ovf = %0d", expected_ovf);
					 $display("Actual ovf = %0d", calculated_ovf);
					 #10;
					 $finish;
				end else begin
					 $display("A = %0d, B = %0d", data_operandA, data_operandB);
					 $display("ovf = %0d", expected_ovf);
					 $display("Iteration %0d: PASS", i);
					 $display("");  // Blank line
				end
			end
			#10;
			$display("sub ovf passed!");
		end
	endtask
	 
	task check_add_ovf_rand(); 
		reg expected_ovf;  
		reg calculated_ovf;
		reg same_sign_AB, diff_sign_AS;
		integer i;
		begin
			// Init values
			@(negedge clock);
			ctrl_ALUopcode <= 5'b00000;  // Use non-blocking assignment
			ctrl_shiftamt <= 5'b00000;   // Use non-blocking assignment

			data_operandA <= 32'h00000000;  // Use non-blocking assignment
			data_operandB <= 32'h00000000;  // Use non-blocking assignment
			#10;

			// Random test loop
			@(negedge clock);
			for (i = 0; i < 1000; i = i + 1) begin
				// Generate random values for A and B
				data_operandA <= $random;  // Procedural assignment to assign new values
				data_operandB <= $random;  // Procedural assignment to assign new values

				// Wait for the next clock edge
				@(negedge clock);

				// Compute expected overflow
				same_sign_AB = !(data_operandA[31] ^ data_operandB[31]);  // Check if A and B have the same sign
				diff_sign_AS = (data_operandA[31] ^ data_result[31]);     // Check if A and the result have different signs
				expected_ovf = (same_sign_AB & diff_sign_AS);  // Overflow condition

				// Capture actual overflow
				calculated_ovf = overflow;

				// Compare expected and actual result
				if (expected_ovf !== calculated_ovf) begin
					 $display("Error at iteration %0d:", i);
					 $display("A = %0d, B = %0d", data_operandA, data_operandB);
					 $display("Result = %0d", data_result);
					 $display("Expected ovf = %0d", expected_ovf);
					 $display("Actual ovf = %0d", calculated_ovf);
					 #10;
					 $finish;
				end else begin
					 $display("A = %0d, B = %0d", data_operandA, data_operandB);
					 $display("ovf = %0d", expected_ovf);
					 $display("Iteration %0d: PASS", i);
					 $display("");  // Blank line
				end
			end
			
			#10;
			$display("add ovf passed!");
		end
	endtask



endmodule
