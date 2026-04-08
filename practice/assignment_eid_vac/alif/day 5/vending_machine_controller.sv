module vending_machine( 
    input clk, rst, 
    input coin1, coin2, 
    output reg dispense 
); 
    typedef enum reg [1:0] {S0=2'b00, S1=2'b01, S2=2'b10} state_t; 
    state_t state, next_state; 
 
    always @(posedge clk or posedge rst) 
        if (rst) state <= S0; else state <= next_state; 
 
    always @(*) begin 
        next_state = state; 
        dispense = 0; 
        case(state) 
            S0: if (coin1 || coin2) next_state = S1; else next_state = S0; 
            S1: if (coin1 || coin2) next_state = S2; else next_state = S1; 
            S2: begin 
                dispense = 1; 
                next_state = S0; 
            end 
        endcase 
    end
endmodule