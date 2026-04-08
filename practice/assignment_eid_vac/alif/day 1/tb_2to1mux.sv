///Testbench 
module tb_mux2to1; 
logic a,b,sel; 
logic y; 
mux2to1 dut(.a(a),.b(b),.sel(sel),.y(y)); 
initial begin 
$dumpfile("mux2to1.vcd"); 
$dumpvars(0,tb_mux2to1); 
a=0; b=1; sel=0; #10; 
a=0; b=1; sel=1; #10; 
a=1; b=0; sel=0; #10; 
a=1; b=0; sel=1; #10; 
$finish; 
end 
endmodule 