//4. LFSR (4-bit example, polynomial x^4+x+1) 
module lfsr_4bit( 
    input clk, rst, 
    output reg [3:0] q 
); 
    always @(posedge clk or posedge rst) begin 
        if(rst) q <= 4'b0001; // seed 
        else q <= {q[2:0], q[3]^q[0]}; // feedback 
    end 
endmodule