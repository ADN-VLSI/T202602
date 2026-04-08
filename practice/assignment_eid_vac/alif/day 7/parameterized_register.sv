//2. Parameterized Register (N-bit wide, synchronous reset) 
module param_reg #( 
    parameter WIDTH=8 
)( 
    input clk, rst, 
    input [WIDTH-1:0] d, 
    output reg [WIDTH-1:0] q 
); 
    always @(posedge clk) begin 
        if(rst) q <= 0; 
        else q <= d; 
    end 
endmodule 