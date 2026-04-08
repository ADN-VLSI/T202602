module traffic_controller(
    input  logic clk,
    input  logic rst,
    input  logic ped_request,
    output logic red,
    output logic yellow,
    output logic green
);

    // State encoding
    typedef enum logic [1:0] {
        RED, GREEN, YELLOW
    } state_t;

    state_t state, next_state;

    logic [3:0] timer;

    // State register
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= RED;
        else
            state <= next_state;
    end

    // Timer logic (RESET when state changes)
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            timer <= 0;
        else if (state != next_state)
            timer <= 0;   // reset timer on state change
        else
            timer <= timer + 1;
    end

    // Next state logic
    always_comb begin
        case(state)

            // 🔴 RED state
            RED: begin
                // Pedestrian request → stay longer in RED
                if (ped_request)
                    next_state = RED;
                else if (timer == 5)
                    next_state = GREEN;
                else
                    next_state = RED;
            end

            // 🟢 GREEN state
            GREEN: begin
                if (timer == 5)
                    next_state = YELLOW;
                else
                    next_state = GREEN;
            end

            // 🟡 YELLOW state
            YELLOW: begin
                if (timer == 3)
                    next_state = RED;
                else
                    next_state = YELLOW;
            end

            default: next_state = RED;
        endcase
    end

    // Output logic
    always_comb begin
        red    = (state == RED);
        green  = (state == GREEN);
        yellow = (state == YELLOW);
    end

endmodule