///5) 8:1 MUX using only 2:1 MUXes 
module mux2(input logic a,b,sel, output logic y); 
 always_comb y = sel ? b : a; 
endmodule 
 
module mux8to1_using2to1( 
 input logic [7:0] d, 
 input logic [2:0] sel, 
output logic y 
); 
logic s0,s1,s2,s3,s4,s5; 
mux2 m1(d[0],d[1],sel[0],s0); 
mux2 m2(d[2],d[3],sel[0],s1); 
mux2 m3(d[4],d[5],sel[0],s2); 
mux2 m4(d[6],d[7],sel[0],s3); 
mux2 m5(s0,s1,sel[1],s4); 
mux2 m6(s2,s3,sel[1],s5); 
mux2 m7(s4,s5,sel[2],y); 
endmodule 