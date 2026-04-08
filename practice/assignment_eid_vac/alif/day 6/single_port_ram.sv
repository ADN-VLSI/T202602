///1. Single-Port RAM (8×8-bit example) 
module single_port_ram( 
    input clk, 
    input we,            // write enable 
    input [2:0] addr,    // 3-bit address for 8 locations 
    input [7:0] din,     // data input 
    output reg [7:0] dout // data output 
); 
    reg [7:0] mem [0:7]; // 8x8-bit RAM 
 
    always @(posedge clk) begin 
        if(we) mem[addr] <= din;  // write 
        dout <= mem[addr];         // read 
    end 
endmodule 