module seqdetect_1011_tb;//overlap
  reg in,clk,rst;
  wire op;
  
  seqdetect_1101 dut(in,clk,rst,op);
  
  initial begin
    clk=1;
    forever #5 clk=~clk;
  end
  initial begin
    rst=0;
    #10;
    rst=1;
    #500;
  end
  initial begin
    $dumpfile("seq_1101.vcd");
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