`timescale 1ns / 1ps

module register_file #(
    parameter DATA_WIDTH = 8,
    parameter NUM_REGS = 8,
    parameter REG_ADDR_WIDTH = 3  // 2^3 = 8
)(
    input clk,
    input we,  // write enable
    input [REG_ADDR_WIDTH-1:0] rs1,  // read addr 1
    input [REG_ADDR_WIDTH-1:0] rs2,  // read addr 2
    input [REG_ADDR_WIDTH-1:0] rd,   // write addr
    input [DATA_WIDTH-1:0] din,
    output [DATA_WIDTH-1:0] dout1,  // read data 1
    output [DATA_WIDTH-1:0] dout2   // read data 2
);

    reg [DATA_WIDTH-1:0] regs [0:NUM_REGS-1];

    // Initialize to 0
    initial begin
        for (int i = 0; i < NUM_REGS; i++) begin
            regs[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (we && rd != 0) begin  // Typically reg 0 is hardwired to 0
            regs[rd] <= din;
        end
    end

    assign dout1 = regs[rs1];
    assign dout2 = regs[rs2];

endmodule