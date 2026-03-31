module tb_param_shift_reg; 
parameter WIDTH=8; 
reg clk, rst, serial_in; 
wire serial_out; 
param_shift_reg #(.WIDTH(WIDTH)) uut(.clk(clk), .rst(rst), .serial_in(serial_in), 
.serial_out(serial_out)); 
initial clk=0; always #5 clk=~clk; 
initial begin 
rst=1; serial_in=0; #10; rst=0; 
serial_in=1; #10; 
serial_in=0; #10; 
serial_in=1; #10; 
serial_in=1; #10; 
$finish; 
end 
endmodule 