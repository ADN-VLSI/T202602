//3. Parameterized Counter (Up, N-bit wide, optional modulo) 
module param_counter #( 
    parameter WIDTH=4, 
    parameter MODULO=(1<<WIDTH) 
)( 
    input clk, rst, 
    output reg [WIDTH-1:0] count 
); 
    always @(posedge clk or posedge rst) begin 
if(rst) count <= 0; 
else if(count == MODULO-1) count <= 0; // wrap around 
else count <= count + 1; 
end 
endmodule