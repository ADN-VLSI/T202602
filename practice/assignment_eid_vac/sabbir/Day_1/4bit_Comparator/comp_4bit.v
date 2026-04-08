module comp_4bit(input [3:0]a,b, output reg a_grt_b,a_less_b,a_eq_b);
  always@(*)
    begin
      if(a>b)
        a_grt_b=1'b1;
      else
        a_grt_b=1'b0;
      
      if(a<b)
        a_less_b=1'b1;
      else
        a_less_b=1'b0;
      
      if(a==b)
        a_eq_b=1'b1;
      else
        a_eq_b=1'b0;
    end
endmodule
        