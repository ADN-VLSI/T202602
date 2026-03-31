///6) 4-bit Adder/Subtractor using Full Adders only 
module full_adder( 
input logic a,b,cin, 
output logic sum,cout 
); 
assign {cout,sum} = a+b+cin; 
endmodule 
module adder_subtractor4( 
input logic [3:0] a,b, 
input logic mode, 
output logic [3:0] sum, 
output logic cout 
); 
logic [3:0] bx; 
logic c1,c2,c3; 
assign bx = b ^ {4{mode}}; 
full_adder fa0(a[0],bx[0],mode,sum[0],c1); 
full_adder fa1(a[1],bx[1],c1,sum[1],c2); 
full_adder fa2(a[2],bx[2],c2,sum[2],c3); 
 full_adder fa3(a[3],bx[3],c3,sum[3],cout); 
endmodule 