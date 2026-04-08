module mod10up_counter(input clk,rst, output reg [3:0]count);
  always@(posedge clk) begin
    if(rst==1)//active high reset
      count<=4'b0000;
    else if(count==4'b1010) 
      count<=4'b0000;
    else
      count=count+1;
  end
endmodule