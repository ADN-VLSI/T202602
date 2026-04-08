`timescale 1ns/1ps

module stopwatch_tb;

    localparam integer CLK_DIV = 5;

    reg        clk;
    reg        rst;
    reg        start;
    wire [5:0] sec;
    wire [5:0] min;

    // ---- DUT ----
    stopwatch #(.CLK_DIV(CLK_DIV)) dut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .sec   (sec),
        .min   (min)
    );

    // ---- Clock: 10 ns period ----
    initial clk = 0;
    always #5 clk = ~clk;

    // ---- Wait N seconds task ----
    task wait_sec;
        input integer n;
        integer i;
        begin
            for (i = 0; i < n * CLK_DIV; i = i + 1)
                @(posedge clk);
        end
    endtask

    // ---- Main Stimulus ----
    initial begin
        $display("============================================");
        $display("  STOPWATCH - MODIFIED SCENARIO");
        $display("  1 sim-second = %0d ns", CLK_DIV * 10);
        $display("============================================");

        // ============================================
        // STEP 1: Reset
        // ============================================
        rst   = 1;
        start = 0;
        repeat(20) @(posedge clk);
        rst = 0;
        repeat(2) @(posedge clk);
        $display("\n[%0t ns] >>> STEP 1: Reset done. sec=%0d min=%0d", $time, sec, min);

        // ============================================
        // STEP 2: Start counting
        // ============================================
        $display("[%0t ns] >>> STEP 2: START counting from 0", $time);
        start = 1;

        // ============================================
        // STEP 3: Count 30 seconds then PAUSE
        // ============================================
        wait_sec(30);
        $display("\n[%0t ns] >>> STEP 3: 30 sec reached. PAUSING now.", $time);
        $display("           sec=%0d  min=%0d", sec, min);
        start = 0;

        // Hold pause for 10 seconds
        wait_sec(10);
        $display("[%0t ns]    Still paused... sec=%0d min=%0d (must NOT change)", $time, sec, min);

        // ============================================
        // STEP 4: Resume counting
        // ============================================
        $display("\n[%0t ns] >>> STEP 4: RESUME counting", $time);
        start = 1;

        // Count 40 more seconds → total counted = 70 sec = 1 min 10 sec
        wait_sec(40);
        $display("\n[%0t ns] >>> Total counted time = 1 min 10 sec", $time);
        $display("           sec=%0d  min=%0d  (expect sec=10 min=1)", sec, min);

        if (min == 1 && sec == 10)
            $display("           >>> PASS <<<");
        else
            $display("           >>> CHECK: sec=%0d min=%0d <<<", sec, min);

        // ============================================
        // STEP 5: Reset at 1 min 10 sec
        // ============================================
        $display("\n[%0t ns] >>> STEP 5: RESET at 1 min 10 sec", $time);
        start = 0;
        rst   = 1;
        repeat(20) @(posedge clk);
        rst = 0;
        repeat(2) @(posedge clk);
        $display("           After reset: sec=%0d min=%0d (expect 0 0)", sec, min);

        if (sec == 0 && min == 0)
            $display("           >>> PASS: Reset OK <<<");
        else
            $display("           >>> FAIL <<<");

        // ============================================
        // STEP 6: Start fresh - count 1 full minute
        // ============================================
        $display("\n[%0t ns] >>> STEP 6: Fresh START - counting 1 full minute", $time);
        start = 1;

        wait_sec(60);
        $display("\n[%0t ns] >>> 60 sec complete.", $time);
        $display("           sec=%0d  min=%0d  (expect sec=0 min=1)", sec, min);

        if (min == 1 && sec == 0)
            $display("           >>> PASS: 1 minute counted correctly <<<");
        else
            $display("           >>> CHECK: sec=%0d min=%0d <<<", sec, min);

        // ============================================
        // DONE
        // ============================================
        $display("\n============================================");
        $display("  SIMULATION COMPLETE");
        $display("============================================");
        $finish;
    end

    // ---- Print every time sec changes ----
    always @(sec) begin
        $display("[%0t ns]  sec=%0d  min=%0d", $time, sec, min);
    end

endmodule
