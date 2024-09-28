module SRA (
    input [31:0] a,    // Input 32-bit value to be shifted
    input [4:0] shamt, // Shift amount (5 bits to cover shifts from 0 to 31)
    output [31:0] y    // Output shifted value
);

    wire [31:0] stage1, stage2, stage3, stage4, stage5;

    // Stage 1: Shift by 16 bits if needed, propagate sign bit
    assign stage1 = (shamt[4]) ? {{16{a[31]}}, a[31:16]} : a;

    // Stage 2: Shift by 8 bits if needed, propagate sign bit
    assign stage2 = (shamt[3]) ? {{8{stage1[31]}}, stage1[31:8]} : stage1;

    // Stage 3: Shift by 4 bits if needed, propagate sign bit
    assign stage3 = (shamt[2]) ? {{4{stage2[31]}}, stage2[31:4]} : stage2;

    // Stage 4: Shift by 2 bits if needed, propagate sign bit
    assign stage4 = (shamt[1]) ? {{2{stage3[31]}}, stage3[31:2]} : stage3;

    // Stage 5: Shift by 1 bit if needed, propagate sign bit
    assign stage5 = (shamt[0]) ? {{1{stage4[31]}}, stage4[31:1]} : stage4;

    // Final output
    assign y = stage5;

endmodule
