///6. Johnson Counter (4-bit example) 
module johnson_counter( 
    input clk, 
    input rst, 
    output reg [3:0] q 
); 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            q <= 4'b0000; 
        else 
            q <= {~q[3], q[3:1]};  // inverted feedback to MSB 
    end 
endmodule 