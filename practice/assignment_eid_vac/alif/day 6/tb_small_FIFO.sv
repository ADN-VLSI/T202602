    module tb_small_fifo; 
    reg clk, rst, wr_en, rd_en; 
    reg [7:0] din; 
    wire [7:0] dout; 
    wire full, empty; 
 
    small_fifo uut(.clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en), 
                   .din(din), .dout(dout), .full(full), .empty(empty)); 
 
    initial clk=0; always #5 clk=~clk; 
 
    initial begin 
        rst=1; wr_en=0; rd_en=0; din=0; #10; 
        rst=0; 
        // write 4 elements 
        wr_en=1; din=8'h11; #10; 
        din=8'h22; #10; 
        din=8'h33; #10; 
        din=8'h44; #10; 
        wr_en=0; rd_en=1; #10; // read elements 
        #40; 
        $finish; 
    end 
endmodule 