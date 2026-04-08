module barrel_shifter_8bit (
    input [7:0] data,
    input [2:0] shift,
    input dir,
    input arith,
    output reg [7:0] shifted
);

    always @(*) begin
        if (dir == 0) begin  // left shift
            shifted = data << shift;
        end else begin  // right shift
            if (arith == 0) begin  // logical right
                shifted = data >> shift;
            end else begin  // arithmetic right
                shifted = $signed(data) >>> shift;
            end
        end
    end

endmodule