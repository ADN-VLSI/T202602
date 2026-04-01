module edge_detector (
    input logic clk,
    input logic rst,
    input logic signal,
    output logic rising_edge,
    output logic falling_edge,
    output logic both_edges
);

    logic prev_signal;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_signal <= 1'b0;
            rising_edge <= 1'b0;
            falling_edge <= 1'b0;
            both_edges <= 1'b0;
        end else begin
            prev_signal <= signal;
            rising_edge <= signal && !prev_signal;
            falling_edge <= !signal && prev_signal;
            both_edges <= rising_edge || falling_edge;
        end
    end

endmodule