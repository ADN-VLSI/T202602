module tb_up_counter_3bit; 
 
    logic clk, rst; 
    logic [2:0] q; 
 
    // Instantiate DUT 
    up_counter_3bit uut(clk, rst, q); 
    // Clock generation 
    always #5 clk = ~clk; // 100MHz -> 50MHz toggle 
    initial begin 
        clk = 0; rst = 1;   // apply reset 
        #10 rst = 0;        // release reset 
        #100 $stop;         // run simulation 
    end 
endmodule 