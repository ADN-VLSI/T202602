///3) Sequence Detector (Shift Register Based) 
module sequence_detector_1011 ( 
    input  logic clk, 
    input  logic rst, 
    input  logic din, 
    output logic detected 
); 
    logic [3:0] shift_reg; 
 
    always_ff @(posedge clk) begin 
        if (rst) 
            shift_reg <= 4'b0000;                  // clear shift register 
        else 
            shift_reg <= {shift_reg[2:0], din};   // shift incoming bit 
    end 
 
    assign detected = (shift_reg == 4'b1011);     // detect pattern 
endmodule