///TB 
module tb_sipo_shift_reg; 
    parameter N = 4; 
    logic clk, rst, serial_in; 
    logic [N-1:0] parallel_out; 
 
    // Instantiate DUT 
    sipo_shift_reg #(N) uut(clk, rst, serial_in, parallel_out); 
 
    // Clock generation 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; rst = 1; serial_in = 0; 
        #10 rst = 0; 
 
        // Apply serial input 
        serial_in = 1; #10; 
        serial_in = 0; #10; 
        serial_in = 1; #10; 
        serial_in = 1; #10; 
 
        #20 $stop; 
    end 
endmodule