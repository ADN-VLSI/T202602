///Testbench 
module tb_encoder8to3; 
logic [7:0] d; 
logic [2:0] y; 
encoder8to3 dut(.d(d),.y(y)); 
initial begin 
$dumpfile("encoder8to3.vcd"); 
$dumpvars(0,tb_encoder8to3); 
d=8'b00010000; #10; 
d=8'b01000000; #10; 
$finish; 
end 
endmodule 