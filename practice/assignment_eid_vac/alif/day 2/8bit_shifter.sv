///2) 8-bit Barrel Shifter 
///RTL 
module barrel_shifter8( 
input  logic [7:0] data_in, 
input  logic [2:0] shamt, 
input  logic [1:0] mode, 
output logic [7:0] data_out 
); 
always_comb begin 
case(mode) 
2'b00: data_out = data_in << shamt;                 
2'b01: data_out = data_in >> shamt;                 
2'b10: data_out = $signed(data_in) >>> shamt; 
default: data_out = data_in; 
endcase 
end 
endmodule 