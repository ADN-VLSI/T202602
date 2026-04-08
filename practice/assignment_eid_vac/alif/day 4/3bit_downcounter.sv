///2.3-bit Down Counter 
module down_counter_3bit( 
    input clk, 
    input rst, 
    output reg [2:0] q 
); 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            q <= 3'b111; // reset counter to max value 
        else 
            q <= q - 1;   // decrement counter 
    end 
endmodule