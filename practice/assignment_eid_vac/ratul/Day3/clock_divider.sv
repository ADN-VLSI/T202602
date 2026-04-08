module clock_divider (
    input logic clk,
    input logic rst,
    input logic [1:0] divide_select,  // 00: /2, 01: /4, 10: /3 (odd)
    output logic clk_div
);

    logic [1:0] counter;
    logic clk_div2, clk_div4, clk_div3;

    // /2 divider
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_div2 <= 1'b0;
        end else begin
            clk_div2 <= ~clk_div2;
        end
    end

    // /4 divider
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b0;
            clk_div4 <= 1'b0;
        end else begin
            if (counter == 2'b01) begin
                counter <= 2'b0;
                clk_div4 <= ~clk_div4;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // /3 divider (odd ratio)
    logic [1:0] counter3;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter3 <= 2'b0;
            clk_div3 <= 1'b0;
        end else begin
            if (counter3 == 2'b10) begin  // after 3 cycles
                counter3 <= 2'b0;
                clk_div3 <= ~clk_div3;
            end else begin
                counter3 <= counter3 + 1;
            end
        end
    end

    // Select output
    always_comb begin
        case (divide_select)
            2'b00: clk_div = clk_div2;
            2'b01: clk_div = clk_div4;
            2'b10: clk_div = clk_div3;
            default: clk_div = clk_div2;
        endcase
    end

endmodule