module tb_barrel_shifter8; 
// logical left 
// logical right 
      //
 arithmetic right 
logic [7:0] data_in,data_out; logic [2:0] shamt; logic [1:0] mode; 
barrel_shifter8 dut(.*); 
initial begin 
$dumpfile("barrel.vcd"); $dumpvars(0,tb_barrel_shifter8); 
data_in=8'b10110011; shamt=2; 
mode=0; #1; assert(data_out==(data_in<<2)); 
mode=1; #1; assert(data_out==(data_in>>2)); 
mode=2; #1; assert(data_out==($signed(data_in)>>>2)); 
$finish; 
end 
endmodule 