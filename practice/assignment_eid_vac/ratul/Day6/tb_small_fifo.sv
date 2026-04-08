`timescale 1ns / 1ps

module tb_small_fifo;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 8;

    reg clk, rst, wr_en, rd_en;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire full, empty;

    small_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("small_fifo.vcd");
        $dumpvars(0, tb_small_fifo);

        rst = 1;
        wr_en = 0; rd_en = 0; din = 0;
        #10;
        rst = 0;
        #10;

        // Test 1: Write until full
        for (int i = 0; i < DEPTH; i++) begin
            if (!full) begin
                din = i;
                wr_en = 1;
                #10;
                wr_en = 0;
                #10;
            end
        end
        if (full) $display("Test 1 PASS: FIFO full");
        else $display("Test 1 FAIL");

        // Test 2: Try to write when full (should not write)
        din = 8'hFF;
        wr_en = 1;
        #10;
        wr_en = 0;
        #10;
        if (full) $display("Test 2 PASS: Still full after attempted write");

        // Test 3: Read until empty
        for (int i = 0; i < DEPTH; i++) begin
            if (!empty) begin
                rd_en = 1;
                #10;
                rd_en = 0;
                #10;
                $display("Read: %d", dout);
            end
        end
        if (empty) $display("Test 3 PASS: FIFO empty");
        else $display("Test 3 FAIL");

        // Test 4: Try to read when empty
        rd_en = 1;
        #10;
        rd_en = 0;
        #10;
        if (empty) $display("Test 4 PASS: Still empty after attempted read");

        // Test 5: Simultaneous wr and rd when not full/empty
        din = 8'hAA;
        wr_en = 1; rd_en = 1;
        #10;
        wr_en = 0; rd_en = 0;
        #10;
        $display("Simultaneous wr/rd: dout=%h, full=%b, empty=%b", dout, full, empty);

        // Test 6: Fill and read one by one
        for (int i = 0; i < DEPTH; i++) begin
            din = i + 10;
            wr_en = 1;
            #10;
            wr_en = 0;
            rd_en = 1;
            #10;
            rd_en = 0;
            #10;
            $display("Wr %d, Rd %d", i+10, dout);
        end

        #20;
        $finish;
    end

endmodule