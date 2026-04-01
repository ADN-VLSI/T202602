module traffic_controller (
    input logic clk,
    input logic rst_n,
    input logic pedestrian_request,
    output logic [2:0] traffic_light,  // [R, Y, G]
    output logic [1:0] pedestrian_light  // [R, G]
);

// Parameters for timing
parameter GREEN_TIME = 10;
parameter YELLOW_TIME = 3;
parameter RED_TIME = 2;
parameter PED_TIME = 5;

// States
typedef enum logic [2:0] {
    TRAFFIC_GREEN = 3'b001,
    TRAFFIC_YELLOW = 3'b010,
    TRAFFIC_RED = 3'b100,
    PEDESTRIAN_GREEN = 3'b101  // Traffic red, ped green
} state_t;

state_t current_state, next_state;

// Timer
logic [3:0] timer;  // Enough for max time
logic timer_done;

// Pedestrian request latch
logic ped_req_latched;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= TRAFFIC_GREEN;
        timer <= GREEN_TIME;
        ped_req_latched <= 0;
    end else begin
        current_state <= next_state;
        if (timer_done) begin
            case (next_state)
                TRAFFIC_GREEN: timer <= GREEN_TIME;
                TRAFFIC_YELLOW: timer <= YELLOW_TIME;
                TRAFFIC_RED: timer <= RED_TIME;
                PEDESTRIAN_GREEN: timer <= PED_TIME;
            endcase
        end else begin
            timer <= timer - 1;
        end
        // Latch pedestrian request
        if (pedestrian_request) ped_req_latched <= 1;
        else if (current_state == PEDESTRIAN_GREEN && timer_done) ped_req_latched <= 0;
    end
end

assign timer_done = (timer == 0);

// Next state logic
always_comb begin
    next_state = current_state;
    case (current_state)
        TRAFFIC_GREEN: begin
            if (timer_done) next_state = TRAFFIC_YELLOW;
        end
        TRAFFIC_YELLOW: begin
            if (timer_done) begin
                if (ped_req_latched) next_state = PEDESTRIAN_GREEN;
                else next_state = TRAFFIC_RED;
            end
        end
        TRAFFIC_RED: begin
            if (timer_done) next_state = TRAFFIC_GREEN;
        end
        PEDESTRIAN_GREEN: begin
            if (timer_done) next_state = TRAFFIC_RED;
        end
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        TRAFFIC_GREEN: begin
            traffic_light = 3'b001;  // G
            pedestrian_light = 2'b10;  // R
        end
        TRAFFIC_YELLOW: begin
            traffic_light = 3'b010;  // Y
            pedestrian_light = 2'b10;  // R
        end
        TRAFFIC_RED: begin
            traffic_light = 3'b100;  // R
            pedestrian_light = 2'b10;  // R
        end
        PEDESTRIAN_GREEN: begin
            traffic_light = 3'b100;  // R
            pedestrian_light = 2'b01;  // G
        end
        default: begin
            traffic_light = 3'b000;
            pedestrian_light = 2'b00;
        end
    endcase
end

endmodule