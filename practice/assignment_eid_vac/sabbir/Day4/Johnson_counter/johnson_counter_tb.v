module johnson_counter_tb;
  reg clk_tb,rst_tb;
  wire [2:0] count_tb;

  johnson_counter dut(clk_tb,rst_tb,count_tb);
  
  initial begin
    // $dumpfile("johnson.vcd");
    // $dumpvars(1);
    clk_tb=1'b0;
   
  end
  always #5 clk_tb=~clk_tb;
  initial begin
     rst_tb=1'b0;
    #7;
    rst_tb=1'b1;
#150;
    $finish; 
  end
   
endmodule