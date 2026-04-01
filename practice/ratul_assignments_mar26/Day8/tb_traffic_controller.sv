module tb_traffic_controller;

logic clk;
logic rst_n;
logic pedestrian_request;
logic [2:0] traffic_light;
logic [1:0] pedestrian_light;

// Instantiate DUT
traffic_controller dut (
    .clk(clk),
    .rst_n(rst_n),
    .pedestrian_request(pedestrian_request),
    .traffic_light(traffic_light),
    .pedestrian_light(pedestrian_light)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period
end

// Test sequence
initial begin
    // Reset
    rst_n = 0;
    pedestrian_request = 0;
    #10 rst_n = 1;

    // Wait for some cycles
    #90;

    // Pedestrian request
    pedestrian_request = 1;
    #10 pedestrian_request = 0;

    // Wait
    #90;

    // Another request
    pedestrian_request = 1;
    #10 pedestrian_request = 0;

    #90;

    $finish;
end

// Monitor
initial begin
    $monitor("Time: %0t, State: Traffic[%b] Ped[%b], Ped Req: %b",
             $time, traffic_light, pedestrian_light, pedestrian_request);
end

endmodule