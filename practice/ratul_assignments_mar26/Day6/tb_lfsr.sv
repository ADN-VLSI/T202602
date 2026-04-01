`timescale 1ns / 1ps

module tb_lfsr;

    reg clk, rst, en;
    wire [7:0] lfsr_out;

    lfsr_8bit dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .lfsr_out(lfsr_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("lfsr.vcd");
        $dumpvars(0, tb_lfsr);

        rst = 1;
        en = 0;
        #10;
        rst = 0;
        #10;

        // Test 1: Reset
        if (lfsr_out == 8'b00000001) $display("Test 1 PASS: Reset to seed");
        else $display("Test 1 FAIL: %b", lfsr_out);

        // Test 2: Enable and shift
        en = 1;
        #10;
        $display("After 1 shift: %b", lfsr_out);
        #10;
        $display("After 2 shifts: %b", lfsr_out);

        // Test 3: Disable
        en = 0;
        #20;
        $display("After disable: %b (should be same)", lfsr_out);

        // Test 4: Run for a few cycles
        en = 1;
        for (int i = 0; i < 10; i++) begin
            #10;
            $display("Cycle %d: %b", i+3, lfsr_out);
        end

        // Test 5: Reset during operation
        rst = 1;
        #10;
        rst = 0;
        #10;
        if (lfsr_out == 8'b00000001) $display("Test 5 PASS: Reset works");
        else $display("Test 5 FAIL");

        #20;
        $finish;
    end

endmodule