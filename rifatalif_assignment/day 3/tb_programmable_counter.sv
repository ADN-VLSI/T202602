module tb_programmable_counter; 
 
    logic clk, rst, up_down, load; 
    logic [3:0] load_value; 
    logic [3:0] count; 
    logic tc; 
 
    programmable_counter uut(clk, rst, up_down, load, load_value, count, tc); 
 
    // Clock generation 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; 
 
        // Reset 
        rst = 1; #10; 
        rst = 0; 
 
        // Load value 
        load = 1; load_value = 4'd5; #10; 
        load = 0; 
 
        // Count up 
        up_down = 1; 
        repeat(10) #10; 
 
        // Count down 
        up_down = 0; 
        repeat(10) #10; 
 
        $finish; 
    end 
 
endmodule