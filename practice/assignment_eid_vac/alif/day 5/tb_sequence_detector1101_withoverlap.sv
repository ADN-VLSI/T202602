 
module tb_seq_detector_1101; 
    reg clk, rst, din; 
    wire detected; 
 
    seq_detector_1101 uut(.clk(clk), .rst(rst), .din(din), .detected(detected)); 
 
    initial clk = 0; always #5 clk = ~clk; 
 
    initial begin 
        rst = 1; din = 0; #10; 
        rst = 0; 
 
        // Test overlapping sequence 
        din = 1; #10; // 1 
        din = 1; #10; // 11 
        din = 0; #10; // 110 
        din = 1; #10; // 1101 => detected 
        din = 1; #10; // 1011? => check overlap 
        din = 0; #10;  
        din = 1; #10;  
 
        $finish; 
    end 
endmodule 