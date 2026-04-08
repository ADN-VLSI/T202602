///2) 4:1 MUX 
///RTL 
module mux4to1( 
input  logic [3:0] d, 
input  logic [1:0] sel, 
output logic y 
); 
always_comb begin 
case(sel) 
2'b00: y = d[0]; 
2'b01: y = d[1]; 
2'b10: y = d[2]; 
2'b11: y = d[3]; 
endcase 
end 
end module