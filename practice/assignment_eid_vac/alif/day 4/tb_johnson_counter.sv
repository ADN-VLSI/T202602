//TB 
module tb_johnson_counter; 
 
    logic clk, rst; 
    logic [3:0] q; 
 
    // Instantiate DUT 
    johnson_counter uut(clk, rst, q); 
 
    // Clock generation 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; rst = 1;            // apply reset 
        #10 rst = 0;                  // release reset 
 
        #80;                          // run for 80 ns to see full sequence 
        $stop; 
    end 
endmodule