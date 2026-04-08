 
//Testbench 
 
module tb_seq_detector_1011; 
    reg clk, rst, din; 
    wire detected; 
 
    seq_detector_1011 uut(.clk(clk), .rst(rst), .din(din), .detected(detected)); 
 
    initial clk = 0; 
    always #5 clk = ~clk; 
 
    initial begin 
        rst = 1; din = 0; #10; 
        rst = 0; 
 
        // Test pattern 
        din = 1; #10; // 1 
        din = 0; #10; // 10 
        din = 1; #10; // 101 
        din = 1; #10; // 1011 => detected 
 
        din = 0; #10; // reset 
        din = 1; #10; // 1 
        din = 0; #10; // 10 
        din = 1; #10; // 101 
        din = 0; #10; // 1010 => not detected 
 
        $finish; 
    end 
endmodule 