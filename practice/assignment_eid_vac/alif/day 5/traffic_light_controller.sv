///3.Traffic Light Controller (3-color: Red, Yellow, Green) 
module traffic_light( 
    input clk, rst, 
    output reg [2:0] light // 3-bit: R,Y,G 
); 
    typedef enum reg [1:0] {RED=2'b00, GREEN=2'b01, YELLOW=2'b10} state_t; 
    state_t state, next_state; 
 
    always @(posedge clk or posedge rst) 
        if (rst) state <= RED; else state <= next_state; 
 
    always @(*) begin 
        case(state) 
            RED: next_state = GREEN; 
            GREEN: next_state = YELLOW; 
            YELLOW: next_state = RED; 
            default: next_state = RED; 
        endcase 
    end 
 
    always @(*) begin 
        light = 3'b000; 
        case(state) 
            RED: light = 3'b100; 
            GREEN: light = 3'b001; 
            YELLOW: light = 3'b010; 
        endcase 
    end 
endmodule 