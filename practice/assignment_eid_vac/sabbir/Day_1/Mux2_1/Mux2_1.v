module mux2_1 (input s,input [1:0] i, output reg y);
  always @(*)
    begin
      if(s==0)
        y=i[0];
      else 
        y=i[1];
    end
endmodule
