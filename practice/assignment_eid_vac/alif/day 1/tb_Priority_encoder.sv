Testbench 
module tb_priority_encoder8to3; 
    logic [7:0] d; 
    logic [2:0] y; 
    logic valid; 
 
    priority_encoder8to3 dut(.d(d),.y(y),.valid(valid)); 
 
    initial begin 
$dumpfile("priority_encoder.vcd"); 
$dumpvars(0,tb_priority_encoder8to3); 
d=8'b00010100; #10; // priority = 4 
d=8'b10000101; #10; // priority = 7 
d=8'b00000000; #10; // invalid 
$finish; 
end 
endmodule 