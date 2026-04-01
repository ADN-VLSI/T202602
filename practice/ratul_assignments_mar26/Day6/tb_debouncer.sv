`timescale 1ns / 1ps

module tb_debouncer;

    parameter DEBOUNCE_DELAY = 10;

    reg clk, rst, noisy_in;
    wire clean_out;

    debouncer #(.DEBOUNCE_DELAY(DEBOUNCE_DELAY)) dut (
        .clk(clk),
        .rst(rst),
        .noisy_in(noisy_in),
        .clean_out(clean_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("debouncer.vcd");
        $dumpvars(0, tb_debouncer);

        rst = 1;
        noisy_in = 0;
        #10;
        rst = 0;
        #10;

        // Test 1: Stable low
        noisy_in = 0;
        #90;  // More than delay
        if (clean_out == 0) $display("Test 1 PASS: Stable low");

        // Test 2: Glitch (short high)
        noisy_in = 1;
        #20;  // Less than delay
        noisy_in = 0;
        #50;
        if (clean_out == 0) $display("Test 2 PASS: Glitch ignored");

        // Test 3: Stable high
        noisy_in = 1;
        #90;
        if (clean_out == 1) $display("Test 3 PASS: Stable high");

        // Test 4: Another glitch
        noisy_in = 0;
        #10;
        noisy_in = 1;
        #50;
        if (clean_out == 1) $display("Test 4 PASS: Glitch after stable");

        // Test 5: Reset
        rst = 1;
        #10;
        rst = 0;
        #10;
        if (clean_out == 0) $display("Test 5 PASS: Reset to 0");

        #20;
        $finish;
    end

endmodule