module mux8_1_tb;

  reg  [7:0] i_top_tb;
  reg  [2:0] s_top_tb;
  wire       y_top_tb;
  reg        exp;

  integer i, j;
  integer pass = 0, fail = 0;

  // DUT
  mux8_1 uut (
    .i_top(i_top_tb),
    .s_top(s_top_tb),
    .y_top(y_top_tb)
  );
  
   

  initial begin
//    $dumpfile("mux8_1_tb.vcd");
//    $dumpvars(0, mux8_1_tb);

    // Test all possible input combinations
    for (i = 0; i < 256; i = i + 1) begin
      i_top_tb = i[7:0];

      for (j = 0; j < 8; j = j + 1) begin
        s_top_tb = j[2:0];
        exp = i_top_tb[s_top_tb];
        #10;

        // Self-check
        if (y_top_tb === exp) begin
          pass = pass + 1;
          //$display("PASS | i_top=%b s_top=%b | y=%b", i_top_tb, s_top_tb, y_top_tb);
        end
        else begin
          fail = fail + 1;
          $display("FAIL | i_top=%b s_top=%b | y=%b exp=%b", i_top_tb, s_top_tb, y_top_tb, exp);
        end
      end
    end

    
    $display("TOTAL PASSED = %0d", pass);
    $display("TOTAL FAILED = %0d", fail);

    if (fail == 0)
      $display("ALL TESTS PASSED ✓");
    else
      $display("SOME TESTS FAILED ");

    $finish;
  end

endmodule
        