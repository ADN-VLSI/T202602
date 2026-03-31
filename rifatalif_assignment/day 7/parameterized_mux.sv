//1. Parameterized MUX (N-bit wide, 2^M:1 MUX) 
module param_mux #( 
    parameter WIDTH = 8, // data width 
    parameter SEL_BITS = 2 // select lines for 4:1 MUX (2^2 = 4) 
)( 
    input [WIDTH-1:0] in [0:(1<<SEL_BITS)-1], // array of inputs 
    input [SEL_BITS-1:0] sel,                // select lines 
    output reg [WIDTH-1:0] out 
); 
    always @(*) begin 
        out = in[sel]; // select input 
    end 
endmodule 