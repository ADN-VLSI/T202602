module johnson_counter(input clk,rst, output reg [2:0] count);
  
  always@(negedge clk)
    begin
      if(rst==0)
      	count=4'b0000;
      else begin
        count[2]<=~count[0];
        count[1]<=count[2];
        count[0]<=count[1];
         end
    end
endmodule