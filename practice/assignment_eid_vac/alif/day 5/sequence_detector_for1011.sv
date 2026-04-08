///1. Sequence Detector for 1011 (Non-overlapping) 
module seq_detector_1011( 
    input clk, 
    input rst, 
    input din, 
    output reg detected 
); 
    // State encoding 
    typedef enum reg [2:0] {S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100} state_t; 
    state_t state, next_state; 
 
    // State transition 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            state <= S0; 
        else 
            state <= next_state; 
    end 
 
    // Next state logic 
    always @(*) begin 
        next_state = state; 
        detected = 0; 
        case(state) 
            S0: next_state = (din) ? S1 : S0; 
            S1: next_state = (din) ? S1 : S2; 
            S2: next_state = (din) ? S3 : S0; 
            S3: next_state = (din) ? S4 : S2; 
            S4: begin 
                detected = 1; // sequence detected 
                next_state = S0; 
            end 
        endcase 
    end 
endmodule