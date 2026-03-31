///Testbench 
module tb_decoder3to8; 
logic [2:0] a; 
    logic [7:0] y; 
 
    decoder3to8 dut(.a(a),.y(y)); 
 
    initial begin 
        $dumpfile("decoder3to8.vcd"); 
        $dumpvars(0,tb_decoder3to8); 
 
        for (int i=0;i<8;i++) begin 
            a=i; #10; 
        end 
        $finish; 
    end 
endmodule 
