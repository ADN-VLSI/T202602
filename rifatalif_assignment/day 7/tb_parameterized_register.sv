 
module tb_param_reg; 
    parameter WIDTH=8; 
    reg clk, rst; 
    reg [WIDTH-1:0] d; 
    wire [WIDTH-1:0] q; 
 
    param_reg #(.WIDTH(WIDTH)) uut(.clk(clk), .rst(rst), .d(d), .q(q)); 
 
    initial clk=0; always #5 clk=~clk; 
 
    initial begin 
        rst=1; #10; rst=0; 
        d=8'hA5; #10; 
        d=8'h3C; #10; 
        $finish; 
    end 
endmodule