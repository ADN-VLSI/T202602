`timescale 1ns / 1ps

module lfsr_8bit (
    input clk,
    input rst,
    input en,
    output reg [7:0] lfsr_out
);

    wire feedback;

    assign feedback = lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[3];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 8'b00000001;  // Non-zero seed
        end else if (en) begin
            lfsr_out <= {lfsr_out[6:0], feedback};
        end
    end

endmodule