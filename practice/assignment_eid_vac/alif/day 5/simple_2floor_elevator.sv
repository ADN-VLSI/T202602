//5. Simple 2-Floor Elevator Controller 
module elevator( 
    input clk, rst, 
    input call1, call2, 
    output reg [1:0] floor // 00=G, 01=1 
); 
    typedef enum reg [1:0] {FLOOR0=2'b00, FLOOR1=2'b01} state_t; 
    state_t state, next_state; 
 
    always @(posedge clk or posedge rst) 
        if (rst) state <= FLOOR0; else state <= next_state; 
 
    always @(*) begin 
        case(state) 
            FLOOR0: if(call2) next_state=FLOOR1; else next_state=FLOOR0; 
            FLOOR1: if(call1) next_state=FLOOR0; else next_state=FLOOR1; 
        endcase 
    end 
 
    always @(*) floor = state; 
endmodule 