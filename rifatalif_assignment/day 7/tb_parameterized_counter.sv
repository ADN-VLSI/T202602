module tb_param_counter; 
parameter WIDTH=4, MODULO=10; 
reg clk, rst; 
wire [WIDTH-1:0] count; 
param_counter #(.WIDTH(WIDTH), .MODULO(MODULO)) uut(.clk(clk), .rst(rst), 
.count(count)); 
initial clk=0; always #5 clk=~clk; 
initial begin 
rst=1; #10; rst=0; 
#100; 
$finish; 
end 
endmodule