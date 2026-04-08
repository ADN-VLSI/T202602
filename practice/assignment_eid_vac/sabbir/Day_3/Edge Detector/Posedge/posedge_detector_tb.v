module posedge_detector_tb;
  reg signal,clk;
  wire out;
  
  posedge_detector dut(signal,clk,out);
  
  initial begin 
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    // $dumpfile("edge.vcd");
    // $dumpvars(1);
    signal=0;
    #2;
    
    #1;signal =0;@(posedge clk);
    #1;signal=0;@(posedge clk);
     #1;signal=1;@(posedge clk);
     #1;signal=0;@(posedge clk);
     #1;signal=1;@(posedge clk);
     #1;signal=0;@(posedge clk);
    #5;
    $finish;
  end
endmodule
    