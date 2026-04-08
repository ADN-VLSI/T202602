module tb_pulse_gen; 
reg clk, rst; 
wire pulse; 
pulse_gen uut(.clk(clk), .rst(rst), .pulse(pulse)); 
initial clk=0; always #5 clk=~clk; 
initial begin 
rst=1; #10; rst=0; 
#50; 
$finish; 
end 
endmodule 