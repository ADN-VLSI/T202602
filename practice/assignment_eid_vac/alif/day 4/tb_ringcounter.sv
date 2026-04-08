module tb_ring_counter; 
 
    logic clk, rst; 
    logic [3:0] q; 
 
    // Instantiate DUT 
    ring_counter uut(clk, rst, q); 
 
    // Clock generation 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; rst = 1;            // apply reset 
        #10 rst = 0;                  // release reset 
 
        #50;                          // run for 50 ns 
        $stop; 
    end 
endmodule 