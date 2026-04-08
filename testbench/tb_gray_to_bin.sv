`timescale 1ns / 1ps


module tb_gray_to_bin;


    parameter WIDTH = 8;

   
    reg  [WIDTH-1:0] gray;
    wire [WIDTH-1:0] bin;

  
    gray_to_bin #(.WIDTH(WIDTH)) dut (
        .gray(gray),
        .bin (bin)
    );

   
    function [WIDTH-1:0] ref_gray_to_bin;
        input [WIDTH-1:0] g;
        integer k;
        begin
            ref_gray_to_bin[WIDTH-1] = g[WIDTH-1];
            for (k = WIDTH-2; k >= 0; k = k - 1)
                ref_gray_to_bin[k] = ref_gray_to_bin[k+1] ^ g[k];
        end
    endfunction

   
    integer pass_cnt, fail_cnt;
    integer total = (1 << WIDTH);   // 2^WIDTH test vectors

 
    task apply_and_check;
        input [WIDTH-1:0] gray_in;
        reg   [WIDTH-1:0] expected;
        begin
            gray     = gray_in;
            #10;                          // propagation delay
            expected = ref_gray_to_bin(gray_in);

            if (bin === expected) begin
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("FAIL: gray=%0b  got bin=%0b  expected=%0b",
                          gray_in, bin, expected);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask

  
    integer v;

    initial begin
        pass_cnt = 0;
        fail_cnt = 0;

        $display("====================================================");
        $display(" Gray-to-Binary Self-Checking TB  (WIDTH = %0d)", WIDTH);
        $display("====================================================");

       
        for (v = 0; v < total; v = v + 1) begin

            apply_and_check(v ^ (v >> 1));
        end

        $display("----------------------------------------------------");
        $display(" PASSED: %0d / %0d", pass_cnt, total);
        if (fail_cnt == 0)
            $display(" ALL TESTS PASSED ✓");
        else
            $display(" FAILED: %0d tests ✗", fail_cnt);
        $display("====================================================");

        $finish;
    end

    // Optional waveform dump
    initial begin
        $dumpfile("gray_to_bin.vcd");
        $dumpvars(0, tb_gray_to_bin);
    end

endmodule