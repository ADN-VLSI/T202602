`timescale 1ns/1ps

module tb_dual_port_ram;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 8;
    parameter DEPTH      = 256;

    // Write port signals
    reg                  wr_clk;
    reg                  wr_en;
    reg  [ADDR_WIDTH-1:0] wr_addr;
    reg  [DATA_WIDTH-1:0] wr_data;

    // Read port signals
    reg                  rd_clk;
    reg  [ADDR_WIDTH-1:0] rd_addr;
    wire [DATA_WIDTH-1:0] rd_data;

    // DUT instantiation
    dual_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .wr_clk  (wr_clk),
        .wr_en   (wr_en),
        .wr_addr (wr_addr),
        .wr_data (wr_data),
        .rd_clk  (rd_clk),
        .rd_addr (rd_addr),
        .rd_data (rd_data)
    );

    
    initial wr_clk = 0;
    always #5  wr_clk = ~wr_clk; 

    initial rd_clk = 0;
    always #7  rd_clk = ~rd_clk; 

    
    task write_ram;
        input [ADDR_WIDTH-1:0] addr;
        input [DATA_WIDTH-1:0] data;
        begin
            @(posedge wr_clk); #1;   
            wr_en   = 1;
            wr_addr = addr;
            wr_data = data;
            @(posedge wr_clk); #1;  
            wr_en   = 0;
        end
    endtask

    
    task read_check;
        input [ADDR_WIDTH-1:0] addr;
        input [DATA_WIDTH-1:0] expected;
        begin
            @(posedge rd_clk); #1;
            rd_addr = addr;
            @(posedge rd_clk); #1;   
            if (rd_data === expected)
                $display("PASS | addr=0x%02X | expected=0x%02X | got=0x%02X",
                          addr, expected, rd_data);
            else
                $display("FAIL | addr=0x%02X | expected=0x%02X | got=0x%02X",
                          addr, expected, rd_data);
        end
    endtask

    integer i;

    initial begin
        // Initialise
        wr_en   = 0;
        wr_addr = 0;
        wr_data = 0;
        rd_addr = 0;

        // Reset settle time
        #20;

        $display("\n── Test 1: basic write/read ──");
        write_ram(8'h01, 8'hAA);
        read_check(8'h01, 8'hAA);

        write_ram(8'h02, 8'hCC);
        read_check(8'h02, 8'hCC);


        $display("\n── Test 2: boundary addresses ──");
        write_ram(8'h00, 8'h55);
        read_check(8'h00, 8'h55);

        write_ram(8'hFF, 8'h77);
        read_check(8'hFF, 8'h77);

        $display("\n── Test 3: burst write + read back ──");
        for (i = 0; i < 8; i = i + 1)
            write_ram(i, i * 8'h11);

        for (i = 0; i < 8; i = i + 1)
            read_check(i, i * 8'h11);

    
        $display("\n── Test 4: simultaneous R/W different addresses ──");
        write_ram(8'h10, 8'hAB);
        fork
            begin
                @(posedge wr_clk); #1;
                wr_en = 1; wr_addr = 8'h20; wr_data = 8'hCD;
                @(posedge wr_clk); #1;
                wr_en = 0;
            end
            begin
                @(posedge rd_clk); #1;
                rd_addr = 8'h10;
                @(posedge rd_clk); #1;
                if (rd_data === 8'hAB)
                    $display("PASS | simultaneous read 0x10 = 0x%02X", rd_data);
                else
                    $display("FAIL | simultaneous read 0x10: expected 0xAB, got 0x%02X", rd_data);
            end
        join
        read_check(8'h20, 8'hCD);

        #50;
        $display("\nSimulation complete.");
        $finish;
    end

    // Waveform dump (Icarus / ModelSim)
    initial begin
        $dumpfile("tb_dual_port_ram.vcd");
        $dumpvars(0, tb_dual_port_ram);
    end

endmodule