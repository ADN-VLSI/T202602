module tb_param_mux; 
    parameter WIDTH=8, SEL_BITS=2; 
    reg [WIDTH-1:0] in [0:3]; 
    reg [SEL_BITS-1:0] sel; 
    wire [WIDTH-1:0] out; 
 
    param_mux #(.WIDTH(WIDTH), .SEL_BITS(SEL_BITS)) uut(.in(in), .sel(sel), .out(out)); 
 
    initial begin 
        in[0]=8'hAA; in[1]=8'h55; in[2]=8'hFF; in[3]=8'h00; 
        sel=0; #10; 
        sel=1; #10; 
        sel=2; #10; 
        sel=3; #10; 
        $finish; 
    end 
endmodule