module comp_4bit_tb;
  reg [3:0]a,b;
  wire a_grt_b,a_less_b,a_eq_b;
  
  comp_4bit dut(a,b,a_grt_b,a_less_b,a_eq_b);
  
  initial begin

    a=4'b1100;b=4'b1011;
    #1;
    a=4'b1101;b=4'b1110;
    #1;
    a=4'b1010;b=4'b1010;
    #1;
    
  end