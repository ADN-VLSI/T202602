module tb_single_port_ram; 
    reg clk, we; 
    reg [2:0] addr; 
    reg [7:0] din; 
    wire [7:0] dout; 
 
    single_port_ram uut(.clk(clk), .we(we), .addr(addr), .din(din), .dout(dout)); 
 
    initial clk=0; always #5 clk=~clk; 
 
    initial begin 
        we=1; addr=3'b000; din=8'hA5; #10;  // write A5 at addr 0 
        addr=3'b001; din=8'h3C; #10;         // write 3C at addr 1 
        we=0; addr=3'b000; #10;               // read addr 0 
        addr=3'b001; #10;                     // read addr 1 
        $finish; 
    end 
endmodule 