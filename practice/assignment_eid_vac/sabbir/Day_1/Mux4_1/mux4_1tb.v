module tb;
  reg [1:0]s;
  reg i0_tb;
  reg i1_tb;
  reg i2_tb;
  reg i3_tb;
 
  
  wire y_tb;
  
  mux4_1 a(s,i0_tb,i1_tb,i2_tb,i3_tb,y_tb);
  
  initial
    begin
      
      s=2'b00;i0_tb=0;i1_tb=0;i2_tb=1;i3_tb=0;#3;
      s=2'b01;i0_tb=0;i1_tb=0;i2_tb=1;i3_tb=0;#3;
      s=2'b10;i0_tb=0;i1_tb=0;i2_tb=1;i3_tb=0;#3;
      s=2'b11;i0_tb=0;i1_tb=0;i2_tb=1;i3_tb=0;#3;
  
     end
endmodule  