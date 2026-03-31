///Testbench 
module tb_param_alu; 
parameter WIDTH=8; 
reg [WIDTH-1:0] A, B; 
reg [2:0] opcode; 
wire [WIDTH-1:0] Y; 
param_alu #(.WIDTH(WIDTH)) uut(.A(A), .B(B), .opcode(opcode), .Y(Y)); 
initial begin 
A=8'h0F; B=8'hF0; opcode=3'b000; #10; // ADD 
opcode=3'b001; #10; // SUB 
opcode=3'b010; #10; // AND 
opcode=3'b011; #10; // OR 
opcode=3'b100; #10; // XOR 
$finish; 
end 
endmodule