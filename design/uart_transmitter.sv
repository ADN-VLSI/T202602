module uart_transmitter #(
    parameter int CLK_FREQ = 16000000, // 16 MHz
    parameter int BAUD_RATE = 1000000, // 1 Mbps
    parameter int DATA_BITS = 8
) (
    input  logic clk,
    input  logic rst_n,
    input  logic start,                         // start transmission
    input  logic [DATA_BITS-1:0] data_in,       // data to send
    output logic tx,                            // UART TX line
    output logic busy                           // transmitter busy
);

localparam int BIT_PERIOD = CLK_FREQ / BAUD_RATE;

logic [$clog2(BIT_PERIOD)-1:0] clk_cnt;
logic [$clog2(DATA_BITS):0] bit_cnt;
logic [DATA_BITS-1:0] shift_reg;

typedef enum logic [1:0] {
    IDLE  = 2'd0,
    START = 2'd1,
    DATA  = 2'd2,
    STOP  = 2'd3
} state_t;

state_t state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt   <= 0;
        bit_cnt   <= 0;
        shift_reg <= 0;
        state     <= IDLE;
        tx        <= 1;     // idle line is HIGH
        busy      <= 0;
    end else begin
        case (state)
            IDLE: begin
                tx   <= 1;
                busy <= 0;
                clk_cnt <= 0;
                if (start) begin
                    shift_reg <= data_in;
                    state <= START;
                    busy <= 1;
                end
            end

            START: begin
                tx <= 0; // start bit
                if (clk_cnt == BIT_PERIOD-1) begin
                    clk_cnt <= 0;
                    state <= DATA;
                    bit_cnt <= 0;
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end

            DATA: begin
                tx <= shift_reg[0]; // LSB first
                if (clk_cnt == BIT_PERIOD-1) begin
                    clk_cnt <= 0;
                    shift_reg <= shift_reg >> 1;
                    if (bit_cnt == DATA_BITS-1) begin
                        state <= STOP;
                    end
                    bit_cnt <= bit_cnt + 1;
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end

            STOP: begin
                tx <= 1; // stop bit
                if (clk_cnt == BIT_PERIOD-1) begin
                    clk_cnt <= 0;
                    state <= IDLE;
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end
        endcase
    end
end

endmodule