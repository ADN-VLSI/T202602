module comp_4bit_tb;

  // DUT inputs
  reg [3:0] a_tb, b_tb;
  // DUT outputs
  wire a_grt_b_tb, a_less_b_tb, a_eq_b_tb;
  
  // Expected outputs
  reg a_grt_b_exp, a_less_b_exp, a_eq_b_exp;
  
  integer i;

  // Instantiate DUT
  comp_4bit dut(
    .a(a_tb),
    .b(b_tb),
    .a_grt_b(a_grt_b_tb),
    .a_less_b(a_less_b_tb),
    .a_eq_b(a_eq_b_tb)
  );

  // Reference model task
  task model(input [3:0] a_in, input [3:0] b_in,
             output reg grt, output reg less, output reg eq);
    begin
      grt  = (a_in > b_in) ? 1'b1 : 1'b0;
      less = (a_in < b_in) ? 1'b1 : 1'b0;
      eq   = (a_in == b_in) ? 1'b1 : 1'b0;
    end
  endtask

  initial begin
    
    $display("Starting Self-Checking for 4-bit Comparator..");
    

    // possible_i/p_combinations
    for(i = 0; i < 256; i = i + 1) begin
      a_tb = i[7:4];  // upper 4 bits
      b_tb = i[3:0];  // lower 4 bits

      // Calculate expected output
      model(a_tb, b_tb, a_grt_b_exp, a_less_b_exp, a_eq_b_exp);
      #1;  // wait for DUT output to settle

      // Check DUT outputs
      if(a_grt_b_tb !== a_grt_b_exp ||
         a_less_b_tb !== a_less_b_exp ||
         a_eq_b_tb !== a_eq_b_exp) begin
        $display("FAIL: a=%b b=%b | DUT=[%b %b %b] EXP=[%b %b %b]",
                 a_tb, b_tb,
                 a_grt_b_tb, a_less_b_tb, a_eq_b_tb,
                 a_grt_b_exp, a_less_b_exp, a_eq_b_exp);
      end
      else begin
        $display("PASS: a=%b b=%b | DUT=[GT:%b LT:%b EQ:%b]",
                 a_tb, b_tb,
                 a_grt_b_tb, a_less_b_tb, a_eq_b_tb);
      end
    end

    $display("Testbench Finished");
    $finish;
  end

endmodule