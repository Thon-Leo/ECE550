module register(q, d, clk, en, clr);

   // Inputs
   input [31:0] d;   // 32-bit data input
   input clk, en, clr;
   
   // Outputs
   output [31:0] q;  // 32-bit output

   // Instantiate 32 DFFEs
   genvar i;
   generate
      for (i = 0; i < 32; i = i + 1) begin : dffe_loop
         dffe_ref dffe_instance(
            .q(q[i]),      // Connect the output bit
            .d(d[i]),      // Connect the input bit
            .clk(clk),     // Clock signal
            .en(en),       // Enable signal
            .clr(clr)      // Clear signal
         );
      end
   endgenerate
endmodule
