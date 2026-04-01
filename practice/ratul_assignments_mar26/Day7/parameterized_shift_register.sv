module parameterized_shift_register #(parameter WIDTH = 8, parameter DIR = 0) ( // 0: left shift, 1: right shift
    input clk, rst, en, shift_in,
    output reg [WIDTH-1:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) data_out <= 0;
        else if (en) begin
            if (DIR == 0) data_out <= {data_out[WIDTH-2:0], shift_in};
            else data_out <= {shift_in, data_out[WIDTH-1:1]};
        end
    end

endmodule