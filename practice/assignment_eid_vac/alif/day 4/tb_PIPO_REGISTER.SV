`timescale 1ns/1ps

module tb_pipo_register;

    parameter N = 4;

    // Inputs
    logic clk, rst, load;
    logic [N-1:0] data_in;

    // Output
    logic [N-1:0] data_out;

    // DUT
    pipo_register #(N) uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Task for checking output
    task check(input [N-1:0] expected);
        #1;
        if (data_out !== expected) begin
            $error("FAIL: Expected=%b, Got=%b", expected, data_out);
        end else begin
            $display("PASS: data_out=%b", data_out);
        end
    endtask

    initial begin
        $display("===== PIPO Register Test Start =====");

        // Waveform dump
        $dumpfile("pipo.vcd");
        $dumpvars(0, tb_pipo_register);

        clk = 0;
        rst = 1;
        load = 0;
        data_in = 4'b0000;

        #10;
        rst = 0;

        // Test 1: Load data
        data_in = 4'b1010;
        load = 1;
        #10;
        check(4'b1010);

        // Test 2: Hold value (load=0)
        load = 0;
        data_in = 4'b1111;
        #10;
        check(4'b1010); // should not change

        // Test 3: Load new data
        load = 1;
        data_in = 4'b0101;
        #10;
        check(4'b0101);

        // Test 4: Reset
        rst = 1;
        #10;
        check(4'b0000);

        rst = 0;

        // Test 5: Load after reset
        load = 1;
        data_in = 4'b1100;
        #10;
        check(4'b1100);

        $display("===== Test Finished =====");
        $finish;
    end

endmodule