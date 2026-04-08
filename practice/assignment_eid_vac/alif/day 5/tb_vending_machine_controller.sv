module tb_vending_machine; 
    reg clk, rst, coin1, coin2; 
    wire dispense; 
 
    vending_machine uut(.clk(clk), .rst(rst), .coin1(coin1), .coin2(coin2), .dispense(dispense)); 
 
    initial clk = 0; always #5 clk = ~clk; 
 
    initial begin 
        rst = 1; coin1=0; coin2=0; #10; 
        rst = 0; 
 
        coin1=1; coin2=0; #10; 
        coin1=0; coin2=1; #10; // total 2 units => dispense=1 
 
        coin1=1; coin2=1; #10; // dispense immediately next cycle 
        $finish; 
    end 
endmodule