module barrel_shifter_4bit(input [3:0]a,input[1:0]sel, output reg [3:0]y);
  always@(*)
    begin
      case(sel)
        2'b00:y=a>>1;
        2'b01:y=a<<1;
        2'b10:y=$signed(a)>>>1;
        default:y=a;
      endcase
    end
endmodule