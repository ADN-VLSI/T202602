`timescale 1ns / 1ps

module debouncer #(
    parameter DEBOUNCE_DELAY = 10
)(
    input clk,
    input rst,
    input noisy_in,
    output reg clean_out
);

    reg [3:0] counter;  // Assuming DELAY < 16
    reg prev_in;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clean_out <= 0;
            prev_in <= 0;
        end else begin
            if (noisy_in == prev_in) begin
                if (counter < DEBOUNCE_DELAY) begin
                    counter <= counter + 1;
                end else begin
                    clean_out <= noisy_in;
                end
            end else begin
                counter <= 0;
                prev_in <= noisy_in;
            end
        end
    end

endmodule