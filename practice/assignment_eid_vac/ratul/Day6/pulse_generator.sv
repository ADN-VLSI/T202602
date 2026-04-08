`timescale 1ns / 1ps

module pulse_generator (
    input clk,
    input rst,
    input trigger,
    output reg pulse
);

    reg trigger_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pulse <= 0;
            trigger_prev <= 0;
        end else begin
            trigger_prev <= trigger;
            if (trigger && !trigger_prev) begin
                pulse <= 1;
            end else begin
                pulse <= 0;
            end
        end
    end

endmodule