///4) Edge Detector 
module edge_detector ( 
    input  logic clk, 
    input  logic signal_in, 
    output logic rising_edge, 
    output logic falling_edge, 
    output logic both_edge 
); 
    logic prev; 
 
    always_ff @(posedge clk) begin 
        prev <= signal_in;                         // save previous state 
    end 
 
    assign rising_edge  =  signal_in & ~prev;     // low to high 
    assign falling_edge = ~signal_in &  prev;     // high to low 
    assign both_edge    = signal_in ^ prev;       // any change 
endmodule