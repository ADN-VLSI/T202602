module mux2_1(input [1:0]i,input s,output reg y);
   always@(*)
      begin
        case(s)
           1'b0:y=i[0];
           1'b1:y=i[1];
          default:y='bx;
         endcase
       end
endmodule

module mux8_1(input [7:0] i_top, input [2:0] s_top, output y_top);
  wire [6:1] x;
  
  mux2_1 m1(.i({i_top[1], i_top[0]}), .s(s_top[0]), .y(x[1]));
  mux2_1 m2(.i({i_top[3], i_top[2]}), .s(s_top[0]), .y(x[2]));
  mux2_1 m3(.i({i_top[5], i_top[4]}), .s(s_top[0]), .y(x[3]));
  mux2_1 m4(.i({i_top[7], i_top[6]}), .s(s_top[0]), .y(x[4]));
  mux2_1 m5(.i({x[2], x[1]}),.s(s_top[1]), .y(x[5]));
  mux2_1 m6(.i({x[4], x[3]}),.s(s_top[1]), .y(x[6]));
  mux2_1 m7(.i({x[6], x[5]}),.s(s_top[2]), .y(y_top));
endmodule