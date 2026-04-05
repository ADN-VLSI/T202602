module bin2gray_tb;
  parameter n=4;
  
  reg [n-1:0] bin;
  wire [n-1:0] gray_op;
 
  bin2gray dut(bin,gray_op);
  initial begin
    //$monitor("bin=%b,gray_op=%b",bin,gray_op);
    bin=4'b1101;
    #5;
    bin=4'b1010;
    
   #5;
    $finish;
  end
endmodule
  