///4.Up/Down Counter 
module up_down_counter( 
    input clk, 
    input rst, 
    input up_down,  // 1: up, 0: down 
    output reg [2:0] q 
); 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            q <= 3'b000; 
        else if (up_down) 
            q <= q + 1; // increment 
        else 
            q <= q - 1; // decrement 
    end 
endmodule