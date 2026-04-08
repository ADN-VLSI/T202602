///1.3-bit Up Counter 
module up_counter_3bit( 
    input clk, 
    input rst, 
    output reg [2:0] q 
); 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            q <= 3'b000; // reset counter to 0 
        else 
            q <= q + 1;   // increment counter 
    end 
endmodule