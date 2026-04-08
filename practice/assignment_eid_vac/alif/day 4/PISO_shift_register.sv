module piso_shift_reg #(parameter N=4)( 
    input clk, 
    input rst, 
    input load, 
    input [N-1:0] parallel_in, 
    output reg serial_out 
); 
    reg [N-1:0] q; 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            q <= 0; 
        else if (load) 
            q <= parallel_in; // load parallel input 
        else begin 
            serial_out <= q[N-1]; // output MSB 
            q <= {q[N-2:0], 1'b0}; // shift left 
        end 
    end 
endmodule 