`timescale 1ns/1ps

module tb_edge_detector;

    logic clk, signal_in;
    logic rising_edge, falling_edge, both_edge;

    // DUT instantiation
    edge_detector uut(
        .clk(clk),
        .signal_in(signal_in),
        .rising_edge(rising_edge),
        .falling_edge(falling_edge),
        .both_edge(both_edge)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Task for checking output
    task check(input exp_rise, exp_fall, exp_both);
        #1; // small delay for stable output
        if (rising_edge !== exp_rise || 
            falling_edge !== exp_fall || 
            both_edge !== exp_both) begin
            $error("FAIL: signal=%b | rise=%b fall=%b both=%b",
                    signal_in, rising_edge, falling_edge, both_edge);
        end else begin
            $display("PASS: signal=%b | rise=%b fall=%b both=%b",
                      signal_in, rising_edge, falling_edge, both_edge);
        end
    endtask

    initial begin
        $display("===== Edge Detector Test Start =====");

        // Waveform dump
        $dumpfile("edge_detector.vcd");
        $dumpvars(0, tb_edge_detector);

        clk = 0;
        signal_in = 0;
        #10;

        // --- Test sequence ---

        signal_in = 1; #10;  // rising edge
        check(1,0,1);

        signal_in = 1; #10;  // no edge
        check(0,0,0);

        signal_in = 0; #10;  // falling edge
        check(0,1,1);

        signal_in = 0; #10;  // no edge
        check(0,0,0);

        signal_in = 1; #10;  // rising edge
        check(1,0,1);

        signal_in = 0; #10;  // falling edge
        check(0,1,1);

        signal_in = 1; #10;  // rising edge
        check(1,0,1);

        $display("===== Test Finished =====");
        $finish;
    end

endmodule