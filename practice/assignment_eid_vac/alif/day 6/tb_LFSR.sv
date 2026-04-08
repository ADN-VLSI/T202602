module tb_lfsr_4bit; 
reg clk, rst; 
wire [3:0] q; 
lfsr_4bit uut(.clk(clk), .rst(rst), .q(q)); 
initial clk=0; always #5 clk=~clk; 
initial begin 
rst=1; #10; rst=0; 
#100; 
$finish; 
end 
endmodule