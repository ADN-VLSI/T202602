module parameterized_alu #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a, b,
    input [2:0] op, // 0: add, 1: sub, 2: and, 3: or, 4: xor
    output reg [WIDTH-1:0] result,
    output reg zero, carry
);

    always @(*) begin
        case (op)
            0: {carry, result} = a + b;
            1: {carry, result} = a - b;
            2: begin result = a & b; carry = 0; end
            3: begin result = a | b; carry = 0; end
            4: begin result = a ^ b; carry = 0; end
            default: begin result = 0; carry = 0; end
        endcase
        zero = (result == 0);
    end

endmodule