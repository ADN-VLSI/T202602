module bcd_7segment(input [3:0] bcd,input en, output reg [6:0] segment);
  always@(en or bcd) begin
    if(~en)
      segment=7'bx;
    
    else begin
    case(bcd)
      4'b0000:segment=7'b1111110;
      4'b0001:segment=7'b0110000;
      4'b0010:segment=7'b1101101;
      4'b0011:segment=7'b1111001;
      4'b0100:segment=7'b0110011;
      4'b0101:segment=7'b1011011;
      4'b0110:segment=7'b1011111;
      4'b0111:segment=7'b1110000;
      4'b1000:segment=7'b1111111;
      4'b1001:segment=7'b1111011;
      
    endcase
    end
    
  end
endmodule
      