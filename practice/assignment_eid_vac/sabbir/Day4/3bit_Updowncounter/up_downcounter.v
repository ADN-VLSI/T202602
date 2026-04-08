module up_downcounter(input clk,rst,en,mode, output reg [2:0] count);
  always@(negedge clk) begin
    
      if(rst==0) begin
        count<=3'b000;
      end
    if(en==1) begin
    
      if(mode==0)
        count<=count+1;
      else 
        count<=count-1;
    
    end 
  end
endmodule