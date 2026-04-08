module mod10up_counter_tb;
  reg clk_tb,rst_tb;
  wire [3:0] count_tb;
  mod10up_counter dut(clk_tb,rst_tb,count_tb);
  
  initial begin
    $dumpfile("mod10up_counter.vcd");
    $dumpvars();
    clk_tb=1'b0;
   
  end
  always #5 clk_tb=~clk_tb;
  initial begin
     rst_tb=1'b1;
    #7;
    rst_tb=1'b0;
#150;
    $finish; 
  end
    
    
endmodule