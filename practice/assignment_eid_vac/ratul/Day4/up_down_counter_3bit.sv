module up_down_counter_3bit(
    input clk,
    input rst,
    input up_down, // 1 for up, 0 for down
    output reg [2:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 3'b000;
        end else begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end

endmodule