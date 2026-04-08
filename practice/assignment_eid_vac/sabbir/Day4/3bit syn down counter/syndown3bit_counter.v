module syndown3bit_counter(input clk,rst, output reg [2:0]count);
  always@(negedge clk) begin
    if(rst==0)
      count<=3'b000;
    else 
      count<=count-1;
  end
endmodule