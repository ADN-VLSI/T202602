module pulse_stretcher (
    input logic clk,
    input logic rst,
    input logic pulse_in,
    input logic [3:0] stretch_width,  // number of cycles to stretch
    output logic pulse_out
);

    logic [3:0] counter;
    logic stretching;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 4'b0;
            stretching <= 1'b0;
            pulse_out <= 1'b0;
        end else begin
            if (pulse_in && !stretching) begin
                stretching <= 1'b1;
                counter <= stretch_width;
                pulse_out <= 1'b1;
            end else if (stretching) begin
                if (counter == 4'b0) begin
                    stretching <= 1'b0;
                    pulse_out <= 1'b0;
                end else begin
                    counter <= counter - 1;
                    pulse_out <= 1'b1;
                end
            end else begin
                pulse_out <= 1'b0;
            end
        end
    end

endmodule