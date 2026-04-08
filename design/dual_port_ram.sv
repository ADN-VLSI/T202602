`timescale 1ns/1ps
module dual_port_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8,
    parameter DEPTH      = 256
)(
    // Write port
    input  wire                  wr_clk,
    input  wire                  wr_en,
    input  wire [ADDR_WIDTH-1:0] wr_addr,
    input  wire [DATA_WIDTH-1:0] wr_data,

    // Read port
    input  wire                  rd_clk,
    input  wire [ADDR_WIDTH-1:0] rd_addr,
    output reg  [DATA_WIDTH-1:0] rd_data   
);

    // RAM array
    reg [DATA_WIDTH-1:0] ram [0:DEPTH-1];

    always @(posedge wr_clk) begin
        if (wr_en)
            ram[wr_addr] <= wr_data;
    end


    always @(posedge rd_clk) begin
        rd_data <= ram[rd_addr];
    end

endmodule