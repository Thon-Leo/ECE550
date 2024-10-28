module clk_div_4(
    input clk_in,           
    input reset,            
    output wire clk_out     
);

    reg [1:0] count = 2'b00;   
    wire toggle;                

    assign toggle = count[1];    
    assign clk_out = toggle;             

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            count <= 2'b01;
        end else begin
            count <= count + 1;
        end
    end

endmodule 