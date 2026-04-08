module tb_mod10_counter; 
 
    logic clk, rst; 
    logic [3:0] q; 
 
    // Instantiate DUT 
    mod10_counter uut(clk, rst, q); 
 
    // Clock generation 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; rst = 1;      // apply reset 
        #10 rst = 0;           // release reset 
        #100 $stop;            // run simulation 
    end 
endmodule 