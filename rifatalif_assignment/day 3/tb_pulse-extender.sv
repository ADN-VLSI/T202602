//TB 
module tb_pulse_stretcher; 
 
    logic clk, pulse_in; 
    logic pulse_out; 
 
    // Instantiate DUT 
    pulse_stretcher uut(clk, pulse_in, pulse_out); 
 
    // Clock generation 
    always #5 clk = ~clk; 
 
    initial begin 
        clk = 0; pulse_in = 0; 
        #10; 
 
        // Apply single-cycle pulse 
        pulse_in = 1; #10; 
        pulse_in = 0; #50; 
 
        // Apply multiple pulses 
        pulse_in = 1; #10; 
        pulse_in = 0; #30; 
        pulse_in = 1; #10; 
        pulse_in = 0; #50; 
 
        $stop; 
    end 
endmodule