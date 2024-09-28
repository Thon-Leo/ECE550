module csa (
    input [31:0] A, B,   
    input Cin,           
    output [31:0] Sum,   
    output Cout          
);

    // Internal wires
    wire [15:0] sum_lower;    // Sum of the lower 16 bits
    wire [15:0] sum_upper0;   // Upper 16 bits sum assuming carry-in = 0
    wire [15:0] sum_upper1;   // Upper 16 bits sum assuming carry-in = 1
    wire carry_lower;         // Carry-out from lower 16-bit addition
    wire carry_upper0, carry_upper1; // Carry-outs from upper 16 bits

    // Lower 16 bits RCA
    rca_16 rca_lower (
        .A(A[15:0]), 
        .B(B[15:0]), 
        .Cin(Cin), 
        .Sum(sum_lower), 
        .Cout(carry_lower)
    );

    // Upper 16 bits RCA, assuming carry-in = 0
    rca_16 rca_upper0 (
        .A(A[31:16]), 
        .B(B[31:16]), 
        .Cin(1'b0), 
        .Sum(sum_upper0), 
        .Cout(carry_upper0)
    );

    // Upper 16 bits RCA, assuming carry-in = 1
    rca_16 rca_upper1 (
        .A(A[31:16]), 
        .B(B[31:16]), 
        .Cin(1'b1), 
        .Sum(sum_upper1), 
        .Cout(carry_upper1)
    );

    // Select the correct upper sum and carry-out based on carry_lower
    assign Sum[15:0] = sum_lower;  // Lower 16 bits are directly from rca_lower
    assign Sum[31:16] = (carry_lower) ? sum_upper1 : sum_upper0;  // Select sum from upper RCA
    assign Cout = (carry_lower) ? carry_upper1 : carry_upper0;    // Select the correct carry-out

endmodule