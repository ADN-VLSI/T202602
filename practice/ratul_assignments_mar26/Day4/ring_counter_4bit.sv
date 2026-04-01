module ring_counter_4bit(
    input clk,
    input rst,
    output reg [3:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b1000;
        end else begin
            count <= {count[2:0], count[3]};
        end
    end

endmodule