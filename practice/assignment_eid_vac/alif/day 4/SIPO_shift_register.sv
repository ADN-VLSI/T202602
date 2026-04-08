///8. SIPO Shift Register 
module sipo_shift_reg #(parameter N=4)( 
input clk, 
input rst, 
input serial_in, 
output reg [N-1:0] parallel_out 
); 
always @(posedge clk or posedge rst) begin 
if (rst) 
parallel_out <= 0; 
else 
parallel_out <= {parallel_out[N-2:0], serial_in}; // shift serial to parallel 
end 
endmodule 