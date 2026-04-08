module pe4_2tb;
  reg [3:0] d;
  wire [1:0]y;
  
  priority_encoder4_2  b(d,y);
  
  initial 
    begin
    {d}=0;
    end
  
  initial
    begin
      
      d=4'b0001;#10;
      d=4'b1001;#10;
      d=4'b0010;#10;
      d=4'b0100;#10;
      d=4'b0101;#10;
      d=4'b1100;#10;
      d=4'b1000;#10;
    end
endmodule