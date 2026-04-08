///3.Mod-10 Counter 
module mod10_counter( 
    input clk, 
    input rst, 
    output reg [3:0] q 
); 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            q <= 4'b0000;       // reset 
        else if (q == 4'd9) 
            q <= 4'b0000;       // wrap around after 9 
        else 
            q <= q + 1;         // increment 
    end 
endmodule