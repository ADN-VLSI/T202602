module bcd_7segment_tb;

  reg [3:0] bcd_tb;
  reg       en_tb;
  wire [6:0] segment_tb;
  reg [6:0]  exp;
  
  bcd_7segment uut (
    .bcd     (bcd_tb),
    .en      (en_tb),
    .segment (segment_tb)
  );

  integer i, pass=0, fail=0;

  initial begin
    $dumpfile("bcd_7segment_tb.vcd");
    $dumpvars(0, bcd_7segment_tb);

    // ── en=0 test ──────────────────────────────────────────────────
    en_tb=0; bcd_tb=4'h5; #10;
    if (segment_tb===7'bx) begin pass=pass+1; $display("PASS en=0 | seg=%b", segment_tb); end
    else                   begin fail=fail+1; $display("FAIL en=0 | got=%b exp=xxxxxxx", segment_tb); end

    // ── en=1 test ──────────────────────────────────────────────────
    en_tb = 1;
    for (i=0; i<=9; i=i+1) begin
      bcd_tb = i; #10;
      case (i)
        0: exp=7'b1111110;  1: exp=7'b0110000;
        2: exp=7'b1101101;  3: exp=7'b1111001;
        4: exp=7'b0110011;  5: exp=7'b1011011;
        6: exp=7'b1011111;  7: exp=7'b1110000;
        8: exp=7'b1111111;  9: exp=7'b1111011;
      endcase
      #10;
      if (segment_tb===exp) begin pass=pass+1; $display("PASS bcd=%0d segment=%b",i,segment_tb); end
      else                  begin fail=fail+1; $display("FAIL bcd=%0d segment=%b exp=%b",i,segment_tb,exp); end
    end

    $display("%0d PASSED | %0d FAILED", pass, fail);
    $finish;
  end

endmodule