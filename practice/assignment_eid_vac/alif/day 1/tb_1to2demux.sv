///Testbench 
module tb_demux1to2; 
logic din,sel; 
logic y0,y1; 
demux1to2 dut(.din(din),.sel(sel),.y0(y0),.y1(y1)); 
initial begin 
$dumpfile("demux1to2.vcd"); 
$dumpvars(0,tb_demux1to2); 
din=1; sel=0; #10; 
din=1; sel=1; #10; 
$finish; 
end 
endmodule 