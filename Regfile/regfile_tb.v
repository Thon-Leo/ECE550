//// ---------- SAMPLE TEST BENCH ----------
`timescale 1 ns / 100 ps
module regfile_tb();
    // inputs to the DUT are reg type
    reg            clock, ctrl_writeEn, ctrl_reset;
    reg [4:0]     ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    reg [31:0]    data_writeReg;

    // outputs from the DUT are wire type
    wire [31:0] data_readRegA, data_readRegB;

    // Tracking the number of errors
    integer errors;
    integer index;    // for testing...

    // instantiate the DUT
    regfile regfile_ut (clock, ctrl_writeEn, ctrl_reset, ctrl_writeReg,
        ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB);

    // setting the initial values of all the reg
    initial
    begin
        $display($time, " << Starting the Simulation >>");
        clock = 1'b0;    // at time 0
        errors = 0;

        ctrl_reset = 1'b1;    // assert reset
        @(negedge clock);    // wait until next negative edge of clock
        @(negedge clock);    // wait until next negative edge of clock

        ctrl_reset = 1'b0;    // de-assert reset
        @(negedge clock);    // wait until next negative edge of clock

        // Begin testing... (loop over registers)
        for(index = 1; index <= 31; index = index + 1) begin
            writeRegister(index, 32'h0000DEAD);
            checkRegister(index, 32'h0000DEAD);
        end

        if (errors == 0) begin
            $display("The simulation completed without errors");
        end
        else begin
            $display("The simulation failed with %d errors", errors);
        end

        $stop;
    end


    // Clock generator
    always
         #10     clock = ~clock;    // toggle

    // Task for writing
    task writeRegister;

        input [4:0] writeReg;
        input [31:0] value;

        begin
            @(negedge clock);    // wait for next negedge of clock
            $display($time, " << Writing register %d with %h >>", writeReg, value);

            ctrl_writeEn = 1'b1;
            ctrl_writeReg = writeReg;
            data_writeReg = value;

            @(negedge clock); // wait for next negedge, write should be done
            ctrl_writeEn = 1'b0;
        end
    endtask

    // Task for reading
    task checkRegister;

        input [4:0] checkReg;
        input [31:0] exp;

        begin
            @(negedge clock);    // wait for next negedge of clock

            ctrl_readRegA = checkReg;    // test port A
            ctrl_readRegB = checkReg;    // test port B

            @(negedge clock); // wait for next negedge, read should be done

            if(data_readRegA !== exp) begin
                $display("**Error on port A: read %h but expected %h.", data_readRegA, exp);
                errors = errors + 1;
            end

            if(data_readRegB !== exp) begin
                $display("**Error on port B: read %h but expected %h.", data_readRegB, exp);
                errors = errors + 1;
            end
        end
    endtask
endmodule
//module regfile_tb();
//    reg            clock, ctrl_writeEn, ctrl_reset;
//    reg [4:0]     ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
//    reg [31:0]    data_writeReg;
//
//    wire [31:0] data_readRegA, data_readRegB;
//
//    integer errors;
//    integer i;
//
//    reg [31:0] expected_values [31:0];  // Array to store expected values for each register
//    reg [4:0] random_reg;
//    reg [31:0] random_value;
//
//    // instantiate the DUT
//    regfile regfile_ut (clock, ctrl_writeEn, ctrl_reset, ctrl_writeReg,
//        ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB);
//
//    initial begin
//        $display($time, " << Starting the Simulation with Random Testing >>");
//        clock = 1'b0;
//        errors = 0;
//
//        // Assert reset
//        ctrl_reset = 1'b1;
//        @(negedge clock);
//        @(negedge clock);
//        ctrl_reset = 1'b0;
//        @(negedge clock);
//			
//			for (i = 0; i < 31; i=i+1) begin
//				expected_values[i] = 32'b0;
//			end
//			
//        // Randomized test: perform random writes and reads
//        for (i = 0; i < 100; i = i + 1) begin
//            random_reg = $random % 32;           // Generate random register index
//            random_value = $random;              // Generate random 32-bit value
//            writeRegister(random_reg, random_value);  // Write to register
//            expected_values[random_reg] = random_value;  // Store the expected value
//				expected_values[0] = 32'b0;
//				
//            // Randomly check registers
//            random_reg = $random % 32;           // Generate random register index to read
//            checkRegister(random_reg, expected_values[random_reg]);  // Check register
//				#20;
//        end
//
//        if (errors == 0) begin
//            $display("The simulation completed without errors");
//        end
//        else begin
//            $display("The simulation failed with %d errors", errors);
//        end
//
//        $stop;
//    end
//
//    // Clock generator
//    always #10 clock = ~clock;
//
//    task writeRegister;
//        input [4:0] writeReg;
//        input [31:0] value;
//
//        begin
//            @(negedge clock);
//            $display($time, " << Writing register %d with %h >>", writeReg, value);
//
//            ctrl_writeEn = 1'b1;
//            ctrl_writeReg = writeReg;
//            data_writeReg = value;
//
//            @(negedge clock);
//            ctrl_writeEn = 1'b0;
//        end
//    endtask
//
//    task checkRegister;
//        input [4:0] checkReg;
//        input [31:0] exp;
//
//        begin
//            @(negedge clock);
//
//            ctrl_readRegA = checkReg;  // Test port A
//            ctrl_readRegB = checkReg;  // Test port B
//
//            @(negedge clock);
//				
//				
//            if (data_readRegA !== exp) begin
//                $display("**Error on port A: reading from %d, read %h but expected %h.", checkReg, data_readRegA, exp);
//                errors = errors + 1;
//            end
//
//            if (data_readRegB !== exp) begin
//                $display("**Error on port B: reading from %d, read %h but expected %h.", checkReg, data_readRegB, exp);
//                errors = errors + 1;
//            end
//        end
//    endtask
//endmodule
