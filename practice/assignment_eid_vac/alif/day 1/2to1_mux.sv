///1) 2:1 MUX 
///RTL 
module mux2to1( 
input  logic a, 
input  logic b, 
input  logic sel, 
output logic y 
); 
always_comb begin 
y = sel ? b : a; 
end 
endmodule 