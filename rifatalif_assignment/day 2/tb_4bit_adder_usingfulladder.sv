TB 
module tb_adder_subtractor4; 
 
  logic [3:0] a,b; 
  logic mode; 
  logic [3:0] sum; 
  logic cout; 
 
  adder_subtractor4 uut(a,b,mode,sum,cout); 
 
  initial begin 
 
    // Addition test 
    a=4; b=3; mode=0; #10; 
    $display("ADD: %d + %d = %d", a,b,sum); 
 
    // Subtraction test 
    a=7; b=2; mode=1; #10; 
    $display("SUB: %d - %d = %d", a,b,sum); 
 
    // Another test 
    a=5; b=5; mode=1; #10; 
    $display("SUB: %d - %d = %d", a,b,sum); 
 
    $finish; 
  end 
 
endmodule