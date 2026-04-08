///Testbench 
module tb_mux4to1; 
logic [3:0] d; 
logic [1:0] sel; 
logic y; 
mux4to1 dut(.d(d),.sel(sel),.y(y)); 
initial begin 
$dumpfile("mux4to1.vcd"); 
$dumpvars(0,tb_mux4to1); 
d = 4'b1010; 
for (int i=0;i<4;i++) begin 
sel = i; #10; 
end 
$finish; 
end 
endmodule