module programmable_counter (
    input logic clk,
    input logic rst,  // synchronous reset
    input logic up_down,  // 1: up, 0: down
    input logic load,
    input logic enable,
    input logic [7:0] start_value,
    output logic [7:0] count,
    output logic terminal_count
);

    always_ff @(posedge clk) begin
        if (rst) begin
            count <= 8'b0;
            terminal_count <= 1'b0;
        end else if (load) begin
            count <= start_value;
            terminal_count <= 1'b0;
        end else if (enable) begin
            if (up_down) begin
                if (count == 8'hFF) begin
                    count <= 8'h00;
                    terminal_count <= 1'b1;
                end else begin
                    count <= count + 1;
                    terminal_count <= (count == 8'hFE);
                end
            end else begin
                if (count == 8'h00) begin
                    count <= 8'hFF;
                    terminal_count <= 1'b1;
                end else begin
                    count <= count - 1;
                    terminal_count <= (count == 8'h01);
                end
            end
        end else begin
            terminal_count <= 1'b0;
        end
    end

endmodule