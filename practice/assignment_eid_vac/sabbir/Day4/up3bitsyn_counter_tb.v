module up3bitsyn_counter_tb;
  reg clk_tb,rst_tb;
  wire [2:0] count_tb;
  up3bitsyn_counter dut(clk_tb,rst_tb,count_tb);
  
  initial begin
    // $dumpfile("up3bitsyn_counter.vcd");
    // $dumpvars(0, up3bitsyn_counter_tb);
    clk_tb=1'b0;
   
  end
  always #5 clk_tb=~clk_tb;
  initial begin
     rst_tb=1'b0;
    #10;
    rst_tb=1'b1;
#100;
    $finish;
  end
    
    
endmodule
  