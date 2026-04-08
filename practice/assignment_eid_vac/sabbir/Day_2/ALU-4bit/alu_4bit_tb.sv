module alu_4bit_tb;

  // ------------------------
  // Testbench signals (DUT)
  // ------------------------
  logic [3:0] tb_a, tb_b;
  logic [2:0] tb_sel;
  logic [3:0] tb_result;
  logic tb_carry, tb_zero, tb_cmp;

  // ------------------------
  // Reference model signals
  // ------------------------
  logic [3:0] ref_a, ref_b;
  logic [2:0] ref_sel;
  logic [3:0] ref_result;
  logic ref_carry, ref_zero, ref_cmp;

  // ------------------------
  // DUT instantiation
  // ------------------------
  alu_4bit dut (
    .a     (tb_a),
    .b     (tb_b),
    .sel   (tb_sel),
    .result(tb_result),
    .carry (tb_carry),
    .zero  (tb_zero),
    .cmp   (tb_cmp)
  );

  // ------------------------
  // Reference model function
  // ------------------------
  function void model(
    input  logic [3:0] a_in,
    input  logic [3:0] b_in,
    input  logic [2:0] sel_in,
    output logic [3:0] res_out,
    output logic c_out,
    output logic z_out,
    output logic cmp_out
  );
    logic [4:0] tmp;
    c_out  = 0;
    cmp_out = 0;

    case(sel_in)
      3'd0: res_out = a_in & b_in;             // AND
      3'd1: res_out = a_in | b_in;             // OR
      3'd2: res_out = a_in ^ b_in;             // XOR
      3'd3: begin                               // ADD
        tmp = a_in + b_in;
        res_out = tmp[3:0];
        c_out   = tmp[4];
      end
      3'd4: begin                               // SUB
        tmp = a_in - b_in;
        res_out = tmp[3:0];
        c_out   = tmp[4];  // borrow/overflow
      end
      3'd5: begin                               // COMPARE
        cmp_out = (a_in > b_in);
        res_out = 0;
      end
      default: res_out = 0;
    endcase

    z_out = (res_out == 0);
  endfunction

  // ------------------------
  // Stimulus + Self-Checking
  // ------------------------
  initial begin
    $display("Starting 4-bit ALU self-checking testbench...\n");

    for (int i = 0; i < 50; i++) begin
      // Generate random input
      tb_a   = $urandom_range(0, 15);
      tb_b   = $urandom_range(0, 15);
      tb_sel = $urandom_range(0, 5);

      // Copy inputs to reference model
      ref_a   = tb_a;
      ref_b   = tb_b;
      ref_sel = tb_sel;
      
      // Call reference model
      model(ref_a, ref_b, ref_sel,
            ref_result, ref_carry, ref_zero, ref_cmp);


      #1; // wait for DUT output

      
      // Compare outputs & display
      if (tb_result !== ref_result ||
          tb_carry  !== ref_carry  ||
          tb_zero   !== ref_zero   ||
          tb_cmp    !== ref_cmp) begin

        $display("FAIL: sel=%0d | a=%0d b=%0d | DUT=%0d (C=%0b Z=%0b CMP=%0b) | REF=%0d (C=%0b Z=%0b CMP=%0b)",
                 tb_sel, tb_a, tb_b,
                 tb_result, tb_carry, tb_zero, tb_cmp,
                 ref_result, ref_carry, ref_zero, ref_cmp);
      end else begin
        $display("PASS: sel=%0d | a=%0d b=%0d | result=%0d (C=%0b Z=%0b CMP=%0b)",
                 tb_sel, tb_a, tb_b,
                 tb_result, tb_carry, tb_zero, tb_cmp);
      end
    end

    $display("\nTestbench finished.");
    $finish;
  end
  
endmodule