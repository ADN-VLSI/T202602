///1) 4-bit ALU 
///RTL 
module alu4bit( 
input  logic [3:0] a, 
input  logic [3:0] b, 
input  logic [2:0] op, 
output logic [3:0] y, 
output logic zero, 
output logic carry, 
output logic gt, 
output logic lt, 
output logic eq 
); 
logic [4:0] temp; 
always_comb begin 
carry = 0; 
gt = 0; lt = 0; eq = 0; 
case(op) 
3'b000: begin temp = a + b; y = temp[3:0]; carry = temp[4]; end 
3'b001: begin temp = a - b; y = temp[3:0]; carry = temp[4]; end 
3'b010: y = a & b; 
3'b011: y = a | b; 
3'b100: y = a ^ b; 
3'b101: begin 
y = 4'b0; 
gt = (a>b); 
lt = (a<b); 
eq = (a==b); 
end 
default: y = 4'b0; 
endcase 
zero = (y == 4'b0); 
end 
endmodule 