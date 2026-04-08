//4.Parameterized Shift Register (N-bit, SISO) 
module param_shift_reg #( 
parameter WIDTH=8 
)( 
input clk, rst, 
input serial_in, 
output reg serial_out 
); 
reg [WIDTH-1:0] shift; 
always @(posedge clk or posedge rst) begin 
if(rst) shift <= 0; 
else shift <= {shift[WIDTH-2:0], serial_in}; // shift left 
end 
assign serial_out = shift[WIDTH-1]; 
endmodule 