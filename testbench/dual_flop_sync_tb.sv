`timescale 1ns/1ps
module tb_sync_2ff;
    reg clk;
    reg rst_n;
    reg [7:0] async_in;
    wire [7:0] sync_out;

    sync_2ff #(8) uut (
        .clk(clk),
        .rst_n(rst_n),
        .async_in(async_in),
        .sync_out(sync_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        async_in = 8'b00000000;
        #3 rst_n = 1;

        @(posedge clk);
        async_in <= 8'b10101010;
        repeat(2) @(posedge clk);
        #1;

        if (sync_out !== 8'b10101010)
            $display("Test 1 FAILED: got %b", sync_out);
        else
            $display("Test 1 PASSED: sync_out = %b", sync_out);

        @(posedge clk);
        async_in <= 8'b11001100;
        repeat(2) @(posedge clk);
        #1;

        if (sync_out !== 8'b11001100)
            $display("Test 2 FAILED: got %b", sync_out);
        else
            $display("Test 2 PASSED: sync_out = %b", sync_out);

        #20 $finish;
    end
endmodule