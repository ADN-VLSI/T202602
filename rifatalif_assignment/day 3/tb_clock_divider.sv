//TB 
module tb_clock_divider; 
 
    logic clk, rst; 
    logic clk_div2, clk_div4; 
 
    // Instantiate DUT 
    clock_divider uut(clk, rst, clk_div2, clk_div4); 
 
    // Clock generation 
    always #5 clk = ~clk; // 100MHz -> 50MHz toggle 
 
    initial begin 
        clk = 0; rst = 1; 
        #10 rst = 0;       // release reset 
        #200 $stop;        // run simulation 
    end 
endmodule 