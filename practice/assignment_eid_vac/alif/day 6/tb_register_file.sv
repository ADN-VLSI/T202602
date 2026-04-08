module tb_reg_file; 
    reg clk, we; 
    reg [1:0] waddr, raddr1, raddr2; 
    reg [7:0] wdata; 
    wire [7:0] rdata1, rdata2; 
 
    reg_file uut(.clk(clk), .we(we), .waddr(waddr), .wdata(wdata), 
                 .raddr1(raddr1), .raddr2(raddr2), 
                 .rdata1(rdata1), .rdata2(rdata2)); 
 
    initial clk=0; always #5 clk=~clk; 
 
    initial begin 
        we=1; waddr=0; wdata=8'hAA; #10; 
        waddr=1; wdata=8'h55; #10; 
        we=0; raddr1=0; raddr2=1; #10; // read back 
        $finish; 
    end 
endmodule