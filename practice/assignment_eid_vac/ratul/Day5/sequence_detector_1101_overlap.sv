module sequence_detector_1101_overlap (
    input logic clk,
    input logic rst,
    input logic in,
    output logic out
);

    typedef enum logic [2:0] {S0, S1, S2, S3, S4} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= S0;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        out = 0;
        case (state)
            S0: if (in) next_state = S1;
            S1: if (in) next_state = S2; else next_state = S0;
            S2: if (!in) next_state = S3;
            S3: if (in) next_state = S4;
            S4: begin
                out = 1;
                next_state = S1;  // Overlap, since last bit 1
            end
        endcase
    end

endmodule