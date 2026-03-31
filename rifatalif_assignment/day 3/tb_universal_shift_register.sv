///Testbench 
module tb_universal_shift_register; 
    logic clk=0,rst,serial_in; 
    logic [1:0] mode; 
    logic [3:0] parallel_in,q; 
    universal_shift_register dut(.*); 
 
    always #5 clk = ~clk; // 10 time unit clock 
 
    initial begin 
        $dumpfile("usr.vcd"); 
        $dumpvars(0,tb_universal_shift_register); 
        rst=1; #10; rst=0; 
        mode=2'b11; parallel_in=4'b1010; #10; // load 
        mode=2'b10; serial_in=1; #20;         // shift left twice 
        mode=2'b01; serial_in=0; #20;         // shift right twice 
        mode=2'b00; #10;                      // hold 
        $finish; 
    end 
endmodule