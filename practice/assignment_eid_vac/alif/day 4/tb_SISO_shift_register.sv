module tb_siso_shift_reg; 
    parameter N = 4; 
    logic clk, rst, serial_in; 
    logic [N-1:0] q; 
    // Instantiate DUT 
    siso_shift_reg #(N) uut(clk, rst, serial_in, q); 
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