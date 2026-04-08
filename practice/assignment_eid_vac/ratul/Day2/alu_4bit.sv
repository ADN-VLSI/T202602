module alu_4bit (
    input [3:0] a,
    input [3:0] b,
    input [2:0] op,
    output reg [3:0] result,
    output reg zero,
    output reg carry
);

    always @(*) begin
        case (op)
            3'b000: {carry, result} = a + b;
            3'b001: {carry, result} = a - b;
            3'b010: begin result = a & b; carry = 0; end
            3'b011: begin result = a | b; carry = 0; end
            3'b100: begin result = a ^ b; carry = 0; end
            3'b101: {carry, result} = a - b;
            default: begin result = 0; carry = 0; end
        endcase
        zero = (result == 0);
    end

endmodule