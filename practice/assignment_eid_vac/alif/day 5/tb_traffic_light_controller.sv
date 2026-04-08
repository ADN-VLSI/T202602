 
module tb_traffic_light; 
    reg clk, rst; 
    wire [2:0] light; 
 
    traffic_light uut(.clk(clk), .rst(rst), .light(light)); 
 
    initial clk = 0; always #5 clk = ~clk; 
 
    initial begin 
        rst = 1; #10; 
        rst = 0; 
        #100; // observe full cycle 
        $finish; 
    end 
endmodule 