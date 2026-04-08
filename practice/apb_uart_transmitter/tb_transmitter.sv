`timescale 1ns/1ps

module uart_transmitter_tb;

    // Parameters (same as DUT)
    parameter int CLK_FREQ  = 16000000;
    parameter int BAUD_RATE = 1000000;
    parameter int DATA_BITS = 8;

    localparam int BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    // Signals
    logic clk;
    logic rst_n;
    logic start;
    logic [DATA_BITS-1:0] data_in;
    logic tx;
    logic busy;

    // DUT instance
    uart_transmitter #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .DATA_BITS(DATA_BITS)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    // Clock generation (16 MHz → period = 62.5 ns)
    always #31.25 clk = ~clk;

    // Task to send one byte
    task send_byte(input [7:0] data);
        begin
            @(posedge clk);
            data_in = data;
            start   = 1;
            @(posedge clk);
            start   = 0;

            // wait until transmission done
            wait (busy == 1);
            wait (busy == 0);
        end
    endtask

    // Monitor TX line
    initial begin
        $monitor("Time=%0t | TX=%b | BUSY=%b", $time, tx, busy);
    end

    // Test sequence
    initial begin
        // Init
        clk = 0;
        rst_n = 0;
        start = 0;
        data_in = 0;

        // Reset
        #100;
        rst_n = 1;

        // Send multiple bytes
        send_byte(8'hA5); // 10100101
        #1000;

        send_byte(8'h3C); // 00111100
        #1000;

        send_byte(8'hFF); // 11111111
        #1000;

        // Finish simulation
        #5000;
        $finish;
    end

endmodule