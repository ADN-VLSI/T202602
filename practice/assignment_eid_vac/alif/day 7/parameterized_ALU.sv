//5. Parameterized ALU (N-bit wide, add/sub/and/or/xor) 
module param_alu #( 
parameter WIDTH=8 
)( 
input [WIDTH-1:0] A, B, 
input [2:0] opcode, // 000=ADD, 001=SUB, 010=AND, 011=OR, 100=XOR 
output reg [WIDTH-1:0] Y 
); 
always @(*) begin 
case(opcode) 
3'b000: Y = A + B; 
3'b001: Y = A - B; 
3'b010: Y = A & B; 
3'b011: Y = A | B; 
3'b100: Y = A ^ B; 
default: Y = 0; 
endcase 
end 
endmodule 