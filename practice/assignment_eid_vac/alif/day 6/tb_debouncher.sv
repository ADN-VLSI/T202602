 
module tb_debouncer; 
    reg clk, btn; 
    wire clean; 
 
    debouncer uut(.clk(clk), .btn(btn), .clean(clean)); 
 
    initial clk=0; always #5 clk=~clk; 
 
    initial begin 
        btn=0; #10; 
        btn=1; #5; btn=0; #5; // bouncing 
        btn=1; #40;            // stable press 
        $finish; 
    end 
endmodule 