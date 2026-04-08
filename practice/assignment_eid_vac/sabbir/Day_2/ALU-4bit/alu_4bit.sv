module alu_4bit (
  input  logic [3:0] a,
  input  logic [3:0] b,
  input  logic [2:0] sel,   // select line
  output logic [3:0] result,
  output logic carry,
  output logic zero,
  output logic cmp          // a > b
);

  logic [4:0] temp;

  always_comb begin
    carry = 0;
    cmp   = 0;

    case (sel)
      3'd0: result = a & b;        // AND
      3'd1: result = a | b;        // OR
      3'd2: result = a ^ b;        // XOR

      3'd3: begin                 // ADD
        temp   = a + b;
        result = temp[3:0];
        carry  = temp[4];
      end

      3'd4: begin                 // SUB
        temp   = a - b;
        result = temp[3:0];
        carry  = temp[4]; // borrow indication (depends on interpretation)
      end

      3'd5: begin                 // COMPARE
        cmp    = (a > b);
        result = 4'b0000;
      end

      default: result = 4'b0000;
    endcase

    zero = (result == 4'b0000);
  end

endmodule
