module SLL (
    input [31:0] a,    // Input 32-bit value to be shifted
    input [4:0] shamt, // Shift amount (5 bits to cover shifts from 0 to 31)
    output [31:0] y    // Output shifted value
);

    wire [31:0] stage1, stage2, stage3, stage4, stage5;

    // Stage 1: Shift by 16 bits if needed
    assign stage1 = (shamt[4]) ? {a[15:0], 16'b0} : a;

    // Stage 2: Shift by 8 bits if needed
    assign stage2 = (shamt[3]) ? {stage1[23:0], 8'b0} : stage1;

    // Stage 3: Shift by 4 bits if needed
    assign stage3 = (shamt[2]) ? {stage2[27:0], 4'b0} : stage2;

    // Stage 4: Shift by 2 bits if needed
    assign stage4 = (shamt[1]) ? {stage3[29:0], 2'b0} : stage3;

    // Stage 5: Shift by 1 bit if needed
    assign stage5 = (shamt[0]) ? {stage4[30:0], 1'b0} : stage4;

    // Final output
    assign y = stage5;

endmodule

