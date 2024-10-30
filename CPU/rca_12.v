// ripple carry adder for 12 bit
module rca_12 (
    input [11:0] A, B,   
    input Cin,           
    output [11:0] Sum,   
    output Cout          
);
    wire [11:0] carry;   

    // Instantiate 12 full adders
    fa FA0 ( .A(A[0]),  .B(B[0]),  .Cin(Cin),      .Sum(Sum[0]),  .Cout(carry[0]) );
    fa FA1 ( .A(A[1]),  .B(B[1]),  .Cin(carry[0]), .Sum(Sum[1]),  .Cout(carry[1]) );
    fa FA2 ( .A(A[2]),  .B(B[2]),  .Cin(carry[1]), .Sum(Sum[2]),  .Cout(carry[2]) );
    fa FA3 ( .A(A[3]),  .B(B[3]),  .Cin(carry[2]), .Sum(Sum[3]),  .Cout(carry[3]) );
    fa FA4 ( .A(A[4]),  .B(B[4]),  .Cin(carry[3]), .Sum(Sum[4]),  .Cout(carry[4]) );
    fa FA5 ( .A(A[5]),  .B(B[5]),  .Cin(carry[4]), .Sum(Sum[5]),  .Cout(carry[5]) );
    fa FA6 ( .A(A[6]),  .B(B[6]),  .Cin(carry[5]), .Sum(Sum[6]),  .Cout(carry[6]) );
    fa FA7 ( .A(A[7]),  .B(B[7]),  .Cin(carry[6]), .Sum(Sum[7]),  .Cout(carry[7]) );
    fa FA8 ( .A(A[8]),  .B(B[8]),  .Cin(carry[7]), .Sum(Sum[8]),  .Cout(carry[8]) );
    fa FA9 ( .A(A[9]),  .B(B[9]),  .Cin(carry[8]), .Sum(Sum[9]),  .Cout(carry[9]) );
    fa FA10 ( .A(A[10]), .B(B[10]), .Cin(carry[9]),  .Sum(Sum[10]), .Cout(carry[10]) );
    fa FA11 ( .A(A[11]), .B(B[11]), .Cin(carry[10]), .Sum(Sum[11]), .Cout(Cout) );
    
endmodule


