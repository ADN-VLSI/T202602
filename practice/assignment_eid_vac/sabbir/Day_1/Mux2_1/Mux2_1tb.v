module tb;
  reg s;
  reg [1:0] i;
  wire y;
  
  mux2_1 a(.s(s),.i(i),.y(y));
  
  initial
    begin
      $monitor("s=%b,y=%b",s,y);
      s=0;i=10;#1;
      s=1;i=10;#1;
     
      
    end
endmodule