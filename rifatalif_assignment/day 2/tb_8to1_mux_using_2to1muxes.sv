module tb_mux8to1; 
logic [7:0] d; 
logic [2:0] sel; 
logic y; 
mux8to1_using2to1 uut(d, sel, y); 
initial begin 
d = 8'b10101010; // test data 
for(int i=0; i<8; i++) begin 
sel = i; #10; 
$display("sel=%b -> y=%b", sel, y); 
end 
$finish; 
end 
endmodule