    
 module syndown3bit_counter_tb;
  reg clk_tb,rst_tb;
  wire [2:0] count_tb;
  syndown3bit_counter dut(clk_tb,rst_tb,count_tb);
  
  initial begin
    // $dumpfile("syndown3bit_counter.vcd");
    // $dumpvars(1);
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
     