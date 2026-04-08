///2. Register File (4×8-bit, 2 read ports, 1 write port) 
module reg_file( 
    input clk, 
    input we, 
    input [1:0] waddr, 
    input [7:0] wdata, 
    input [1:0] raddr1, raddr2, 
    output reg [7:0] rdata1, rdata2 
); 
    reg [7:0] regs [0:3]; 
 
    always @(posedge clk) begin 
        if(we) regs[waddr] <= wdata; // write 
        rdata1 <= regs[raddr1];       // read1 
        rdata2 <= regs[raddr2];       // read2 
    end 
endmodule