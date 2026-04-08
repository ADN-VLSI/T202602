module seqdetect_1011_tb;
  reg in,clk,rst;
  wire op;
  
  seqdetect_1011 dut(in,clk,rst,op);
  
  initial begin
    clk=1;
    forever #5 clk=~clk;
  end
  initial begin
    rst=0;
    #10;
    rst=1;
    #1000;
  end
  initial begin
    $dumpfile("seq_1011.vcd");
    $dumpvars(1);
    in=0;
    #20;
    in=1;
    #20;
    in=0;
    #10;
    in=1;
    #10;
    in=1;
    #10;
    in=0;
    #10;
    in=1;
    #10;
    in=1;
    #10;
    in=0;
    #10;
    in=1;
    #10;
    in=1;
    #20;
    $finish;
    
  end
endmodule