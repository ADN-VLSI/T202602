`timescale 1ns / 1ps

module tb_single_port_ram;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    reg clk;
    reg we;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;

    single_port_ram #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period
    end

    initial begin
        $dumpfile("single_port_ram.vcd");
        $dumpvars(0, tb_single_port_ram);

        // Initialize
        we = 0;
        addr = 0;
        din = 0;
        #10;

        // Test 1: Write to address 0
        addr = 0;
        din = 8'hAA;
        we = 1;
        #10;
        we = 0;
        #10;
        // Read back
        if (dout == 8'hAA) $display("Test 1 PASS: Read %h from addr 0", dout);
        else $display("Test 1 FAIL: Expected AA, got %h", dout);

        // Test 2: Write to address 15
        addr = 15;
        din = 8'h55;
        we = 1;
        #10;
        we = 0;
        #10;
        if (dout == 8'h55) $display("Test 2 PASS: Read %h from addr 15", dout);
        else $display("Test 2 FAIL: Expected 55, got %h", dout);

        // Test 3: Corner case - Write and read same cycle (read should get old value)
        addr = 1;
        din = 8'hFF;
        we = 1;
        #10;  // At this point, dout should be FF after this cycle
        we = 0;
        #10;
        if (dout == 8'hFF) $display("Test 3 PASS: Read %h after write", dout);
        else $display("Test 3 FAIL: Expected FF, got %h", dout);

        // Test 4: Read from uninitialized address (should be X or 0, depending on sim)
        addr = 2;
        #10;
        $display("Test 4: Read from uninitialized addr 2: %h", dout);

        // Test 5: Full range write/read
        for (int i = 0; i < (1<<ADDR_WIDTH); i++) begin
            addr = i;
            din = i;
            we = 1;
            #10;
            we = 0;
            #10;
            if (dout == i) $display("Addr %d: PASS", i);
            else $display("Addr %d: FAIL, expected %d, got %d", i, i, dout);
        end

        #20;
        $finish;
    end

endmodule