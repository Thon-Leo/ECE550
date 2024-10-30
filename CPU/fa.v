// 1 bit full adder
module fa (
    input A,        
    input B,        
    input Cin,      
    output Sum,     
    output Cout     
);

    // Internal wires
    wire AxorB;     // Result of A XOR B
    wire AandB;     // Result of A AND B
    wire AxorBandCin; // Result of (A XOR B) AND Cin

    xor (AxorB, A, B);
    and (AandB, A, B);
    xor (Sum, AxorB, Cin);
    and (AxorBandCin, AxorB, Cin);
    or (Cout, AandB, AxorBandCin);

endmodule
