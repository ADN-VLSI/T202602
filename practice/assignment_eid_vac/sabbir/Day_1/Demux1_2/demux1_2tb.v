module tb;
  reg s;
  reg i;
  integer m;
  wire [1:0]y;
  
  demux2_1 a(s,i,y);
 
 initial begin //initialization
  {s,i}=2'b00;
  end 
  
 initial begin
    for(m=0;m<4;m=m+1) begin
    #1;
      {s,i}=m;
    end
    
  end
endmodule