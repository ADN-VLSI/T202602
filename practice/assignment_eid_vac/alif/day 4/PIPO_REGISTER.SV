module pipo_register #(parameter N=4)( 
    input clk, 
    input rst, 
    input load, 
    input [N-1:0] data_in, 
    output reg [N-1:0] data_out 
); 
    always @(posedge clk or posedge rst) begin 
        if (rst) 
            data_out <= 0; 
        else if (load) 
            data_out <= data_in; // parallel load 
    end 
endmodule