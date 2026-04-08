module universal_shift_register (
    input logic clk,
    input logic rst,
    input logic [1:0] mode,  // 00: hold, 01: shift left, 10: shift right, 11: parallel load
    input logic serial_in,
    input logic [7:0] parallel_in,
    output logic [7:0] q
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 8'b0;
        end else begin
            case (mode)
                2'b00: q <= q;  // hold
                2'b01: q <= {q[6:0], serial_in};  // shift left
                2'b10: q <= {serial_in, q[7:1]};  // shift right
                2'b11: q <= parallel_in;  // parallel load
            endcase
        end
    end

endmodule