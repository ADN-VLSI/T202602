`timescale 1ns / 1ps

module tb_pulse_generator;

    reg clk, rst, trigger;
    wire pulse;

    pulse_generator dut (
        .clk(clk),
        .rst(rst),
        .trigger(trigger),
        .pulse(pulse)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("pulse_generator.vcd");
        $dumpvars(0, tb_pulse_generator);

        rst = 1;
        trigger = 0;
        #10;
        rst = 0;
        #10;

        // Test 1: Single trigger
        trigger = 1;
        #10;
        trigger = 0;
        #10;
        if (pulse) $display("Test 1 PASS: Pulse generated on trigger");

        // Test 2: Trigger held high (should pulse only once)
        trigger = 1;
        #30;  // Multiple cycles
        trigger = 0;
        #10;
        $display("Test 2: Pulse should be 0 now");

        // Test 3: Multiple triggers
        #10;
        trigger = 1;
        #10;
        trigger = 0;
        #10;
        trigger = 1;
        #10;
        trigger = 0;
        #10;

        // Test 4: Reset
        rst = 1;
        #10;
        rst = 0;
        #10;

        #20;
        $finish;
    end

endmodule