module siso_shift_reg #(parameter N=4)( 
    input clk, 
    input rst, 
    input serial_in, 
    output reg [N-1:0] q 
); 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            q <= 0;                  // reset 
        else 
            q <= {q[N-2:0], serial_in}; // shift left 
    end 
endmodule