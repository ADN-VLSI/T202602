///6) 3:8 Decoder 
///RTL 
module decoder3to8( 
input  logic [2:0] a, 
output logic [7:0] y 
); 
always_comb begin 
y = 8'b00000001 << a; 
end 
endmodule