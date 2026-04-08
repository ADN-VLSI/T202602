module tb_alu4bit; 
logic [3:0] a,b,y; logic [2:0] op; logic zero,carry,gt,lt,eq; 
alu4bit dut(.*); 
initial begin 
$dumpfile("alu4bit.vcd"); $dumpvars(0,tb_alu4bit); 
a=4'd5; b=4'd3; op=3'b000; #1; assert(y==8); 
op=3'b001; #1; assert(y==2); 
op=3'b010; #1; assert(y==(a&b)); 
op=3'b011; #1; assert(y==(a|b)); 
op=3'b100; #1; assert(y==(a^b)); 
op=3'b101; #1; assert(gt==1 && lt==0 && eq==0); 
$finish; 
end 
endmodule 