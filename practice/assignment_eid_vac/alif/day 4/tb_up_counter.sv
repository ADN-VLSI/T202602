///TB 
module tb_up_down_counter; 
 
    logic clk, rst, up_down; 
    logic [2:0] q; 
 
    // Instantiate DUT 
    up_down_counter uut(clk, rst, up_down, q); 
 
    // Clock generation 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; rst = 1; up_down = 1;  // apply reset 
        #10 rst = 0;                     // release reset 
 
        // test up counting 
        up_down = 1; 
        #40; 
 
        // test down counting 
        up_down = 0; 
        #40; 
 
        $stop; 
    end 
endmodule 