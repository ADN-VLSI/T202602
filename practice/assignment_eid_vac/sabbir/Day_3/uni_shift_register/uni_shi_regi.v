module uni_shi_regi(input clk,rst,sr_in,sl_in,
                    input [1:0]sel,
                    input [3:0] p_in,output reg [3:0] out);
  //sr_in=serial right input
  //sl_in=serial left input
  //p_in=parallel input
  always@(posedge clk) begin
    if(rst==0)
      out=4'b0000;
    else begin
    case(sel)
      2'b00:out=out;//hold
      
      2'b01:out={sr_in,out[3:1]};//shift right
                 
      2'b10:out={out[2:0],sl_in};//shift left
                 
      2'b11:out=p_in;//parallel load
      endcase
      end
   end
endmodule