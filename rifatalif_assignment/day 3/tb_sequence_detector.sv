///TB 
module tb_sequence_detector_1011; 
 
    logic clk, rst, din; 
    logic detected; 
 
    sequence_detector_1011 uut(clk, rst, din, detected); 
 
    // Clock generation 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; 
        rst = 1; din = 0; #10; 
        rst = 0; 
 
        // Apply test sequence 
        din = 1; #10; 
        din = 0; #10; 
        din = 1; #10; 
        din = 1; #10;  // pattern 1011 detected here 
 
        din = 0; #10; 
        din = 1; #10; 
        din = 0; #10; 
        din = 1; #10; 
 
        $finish; 
    end 
endmodule