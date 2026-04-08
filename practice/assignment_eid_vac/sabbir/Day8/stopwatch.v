module stopwatch #(
    parameter integer CLK_DIV = 5
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    output reg  [5:0] sec,
    output reg  [5:0] min
);

    integer      div_cnt;
    reg          tick;
    reg          min_tick;

    // ---- Clock Divider: tick every CLK_DIV cycles ----
    always @(posedge clk) begin
        if (rst) begin
            div_cnt <= 0;
            tick    <= 0;
        end else if (start) begin
            if (div_cnt == CLK_DIV - 1) begin
                div_cnt <= 0;
                tick    <= 1;
            end else begin
                div_cnt <= div_cnt + 1;
                tick    <= 0;
            end
        end else begin
            tick <= 0;
        end
    end

    // ---- Seconds Counter 0-59 ----
    always @(posedge clk) begin
        if (rst) begin
            sec      <= 0;
            min_tick <= 0;
        end else if (tick) begin
            if (sec == 59) begin
                sec      <= 0;
                min_tick <= 1;   // one full minute done
            end else begin
                sec      <= sec + 1;
                min_tick <= 0;
            end
        end else begin
            min_tick <= 0;
        end
    end

    // ---- Minutes Counter 0-59 ----
    always @(posedge clk) begin
        if (rst) begin
            min <= 0;
        end else if (min_tick) begin
            if (min == 59)
                min <= 0;
            else
                min <= min + 1;
        end
    end

endmodule
