`timescale 1ns / 1ps

module tb_register_file;

    parameter DATA_WIDTH = 8;
    parameter NUM_REGS = 8;
    parameter REG_ADDR_WIDTH = 3;

    reg clk;
    reg we;
    reg [REG_ADDR_WIDTH-1:0] rs1, rs2, rd;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout1, dout2;

    register_file #(.DATA_WIDTH(DATA_WIDTH), .NUM_REGS(NUM_REGS), .REG_ADDR_WIDTH(REG_ADDR_WIDTH)) dut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .din(din),
        .dout1(dout1),
        .dout2(dout2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("register_file.vcd");
        $dumpvars(0, tb_register_file);

        we = 0;
        rs1 = 0; rs2 = 0; rd = 0; din = 0;
        #10;

        // Test 1: Write to reg 1
        rd = 1;
        din = 8'h11;
        we = 1;
        #10;
        we = 0;
        rs1 = 1;
        #10;
        if (dout1 == 8'h11) $display("Test 1 PASS: Reg 1 = %h", dout1);
        else $display("Test 1 FAIL");

        // Test 2: Write to reg 0 (should not write)
        rd = 0;
        din = 8'hFF;
        we = 1;
        #10;
        we = 0;
        rs1 = 0;
        #10;
        if (dout1 == 0) $display("Test 2 PASS: Reg 0 remains 0");
        else $display("Test 2 FAIL: Reg 0 = %h", dout1);

        // Test 3: Read from two ports
        rd = 2; din = 8'h22; we = 1; #10; we = 0;
        rd = 3; din = 8'h33; we = 1; #10; we = 0;
        rs1 = 2; rs2 = 3;
        #10;
        if (dout1 == 8'h22 && dout2 == 8'h33) $display("Test 3 PASS: dout1=%h, dout2=%h", dout1, dout2);
        else $display("Test 3 FAIL");

        // Test 4: Read same register on both ports
        rs1 = 1; rs2 = 1;
        #10;
        if (dout1 == dout2 && dout1 == 8'h11) $display("Test 4 PASS: Same reg read");
        else $display("Test 4 FAIL");

        // Test 5: Full range
        for (int i = 1; i < NUM_REGS; i++) begin
            rd = i;
            din = i;
            we = 1;
            #10;
            we = 0;
            rs1 = i;
            #10;
            if (dout1 == i) $display("Reg %d: PASS", i);
            else $display("Reg %d: FAIL", i);
        end

        #20;
        $finish;
    end

endmodule