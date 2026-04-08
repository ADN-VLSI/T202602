///TB 
module tb_magnitude_comparator4; 
logic [3:0] a,b; 
logic gt,lt,eq; 
magnitude_comparator4 uut(a,b,gt,lt,eq); 
initial begin 
$display("a b | gt lt eq"); 
    a=4; b=2; #10; // greater 
    $display("%d %d | %b %b %b",a,b,gt,lt,eq); 
 
    a=1; b=5; #10; // less 
    $display("%d %d | %b %b %b",a,b,gt,lt,eq); 
 
    a=3; b=3; #10; // equal 
    $display("%d %d | %b %b %b",a,b,gt,lt,eq); 
 
    $finish; 
  end 
 
endmodule