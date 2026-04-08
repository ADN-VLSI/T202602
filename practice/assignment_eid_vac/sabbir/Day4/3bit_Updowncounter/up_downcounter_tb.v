module up_downcounter_tb;
  reg clk,rst,en,mode;
  wire [2:0] count;
  
  up_downcounter dut(clk,rst,en,mode,count);
  
  initial begin
    $dumpfile("up_downcounter.vcd");
    $dumpvars(1);
  end
  initial begin
    rst=0;
    #13 rst=1;
  end
  initial begin
    en=0;
    mode=0;
    
    
    #17 en=1;
    #80 mode=1;
    #80 mode=0;
    
    #80 $finish;
  end
  initial clk=0;
  always #5 clk=~clk;
    
endmodule
  