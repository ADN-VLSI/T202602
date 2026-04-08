module pipo_register_4bit(
    input clk,
    input rst,
    input [3:0] parallel_in,
    output reg [3:0] parallel_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parallel_out <= 4'b0000;
        end else begin
            parallel_out <= parallel_in;
        end
    end

endmodule