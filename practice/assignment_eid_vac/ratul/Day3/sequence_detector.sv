module sequence_detector (
    input logic clk,
    input logic rst,
    input logic data_in,
    output logic detected
);

    logic [3:0] shift_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 4'b0;
            detected <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data_in};
            detected <= (shift_reg == 4'b1011);
        end
    end

endmodule