module tb_traffic_controller;

    logic clk, rst, ped_request;
    logic red, yellow, green;

    // DUT (Device Under Test)
    traffic_controller uut (
        .clk(clk),
        .rst(rst),
        .ped_request(ped_request),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // Clock generation (10 time unit period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        ped_request = 0;

        // Reset pulse
        #10;
        rst = 0;

        // 🟢 Normal operation
        #60;

        // 🚶 Pedestrian request
        $display("---- Pedestrian Request Triggered ----");
        ped_request = 1;
        #20;
        ped_request = 0;

        // Continue operation
        #100;

        $display("---- Simulation Finished ----");
        $finish;
    end

    // Monitor output (very important for marks)
    initial begin
        $monitor("Time=%0t | RED=%b YELLOW=%b GREEN=%b | PED=%b",
                  $time, red, yellow, green, ped_request);
    end

endmodule