module uart_receiver #(
    parameter int CLK_FREQ = 16000000, // 16 MHz
    parameter int BAUD_RATE = 1000000, // 1 Mbps
    parameter int DATA_BITS = 8,
    parameter int OVERSAMPLE = 16
) (
    input logic clk,
    input logic rst_n,
    input logic rx,
    output logic [DATA_BITS-1:0] data_out,
    output logic data_valid
);

localparam int BIT_PERIOD = CLK_FREQ / BAUD_RATE; // 16
logic [$clog2(BIT_PERIOD)-1:0] clk_cnt;
logic [$clog2(OVERSAMPLE)-1:0] sample_cnt;
logic receiving;
logic [DATA_BITS-1:0] shift_reg;
logic [$clog2(DATA_BITS)-1:0] bit_cnt;
logic [1:0] state; // 0: idle, 1: start, 2: data, 3: stop

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt <= 0;
        sample_cnt <= 0;
        receiving <= 0;
        state <= 0;
        bit_cnt <= 0;
        data_valid <= 0;
        shift_reg <= 0;
    end else begin
        data_valid <= 0;
        if (receiving) begin
            clk_cnt <= clk_cnt + 1;
            if (clk_cnt == BIT_PERIOD - 1) begin
                clk_cnt <= 0;
                sample_cnt <= sample_cnt + 1;
                if (sample_cnt == OVERSAMPLE - 1) begin
                    sample_cnt <= 0;
                    // end of bit
                    if (state == 2) begin
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == DATA_BITS - 1) begin
                            state <= 3;
                        end
                    end else if (state == 3) begin
                        if (rx == 1) begin
                            data_out <= shift_reg;
                            data_valid <= 1;
                        end
                        receiving <= 0;
                        state <= 0;
                    end
                end
                // sample at middle
                if (sample_cnt == OVERSAMPLE/2) begin
                    case (state)
                        1: begin // start
                            if (rx == 0) begin
                                state <= 2;
                                bit_cnt <= 0;
                            end else begin
                                receiving <= 0;
                                state <= 0;
                            end
                        end
                        2: begin // data
                            shift_reg <= {rx, shift_reg[DATA_BITS-1:1]};
                        end
                        3: begin // stop
                            // check at end
                        end
                    endcase
                end
            end
        end else begin
            if (rx == 0) begin
                receiving <= 1;
                state <= 1;
                clk_cnt <= 0;
                sample_cnt <= 0;
            end
        end
    end
end

endmodule