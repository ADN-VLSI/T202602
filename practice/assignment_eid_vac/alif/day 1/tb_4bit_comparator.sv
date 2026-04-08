///Testbench 
module tb_comparator4bit; 
logic [3:0] a,b; 
logic eq,gt,lt; 
comparator4bit dut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt)); 
initial begin 
$dumpfile("comparator4bit.vcd"); 
$dumpvars(0,tb_comparator4bit); 
a=4'd5; b=4'd5; #10; 
a=4'd9; b=4'd3; #10; 
a=4'd2; b=4'd7; #10; 
$finish; 
end 
endmodule