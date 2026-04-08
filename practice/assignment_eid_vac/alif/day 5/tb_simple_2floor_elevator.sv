 
module tb_elevator; 
    reg clk, rst, call1, call2; 
    wire [1:0] floor; 
 
    elevator uut(.clk(clk), .rst(rst), .call1(call1), .call2(call2), .floor(floor)); 
 
    initial clk=0; always #5 clk=~clk; 
 
    initial begin 
        rst=1; call1=0; call2=0; #10; 
        rst=0; 
 
        call2=1; #10; call2=0; #10; // move to floor1 
        call1=1; #10; call1=0; #10; // move back to floor0 
 
        $finish; 
    end 
endmodule