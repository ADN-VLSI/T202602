///2. Sequence Detector for 1101 (with overlap) 
module seq_detector_1101( 
    input clk, rst, din, 
    output reg detected 
); 
    typedef enum reg [2:0] {S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100} state_t; 
    state_t state, next_state; 
 
    always @(posedge clk or posedge rst) 
        if (rst) state <= S0; else state <= next_state; 
 
    always @(*) begin 
        next_state = state; 
        detected = 0; 
        case(state) 
            S0: next_state = (din) ? S1 : S0; 
            S1: next_state = (din) ? S2 : S0; 
            S2: next_state = (din) ? S2 : S3; 
            S3: next_state = (din) ? S4 : S0; 
            S4: begin 
                detected = 1; // sequence detected 
                next_state = (din) ? S2 : S0; // allow overlap 
            end 
        endcase 
    end 
endmodule 