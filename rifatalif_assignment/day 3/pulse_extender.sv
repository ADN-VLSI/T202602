//5) Pulse Stretcher / Pulse Extender 
module pulse_stretcher ( 
    input  logic clk, 
    input  logic pulse_in, 
    output logic pulse_out 
); 
    logic [2:0] stretch_cnt; 
 
    always_ff @(posedge clk) begin 
        if (pulse_in) 
            stretch_cnt <= 3'd4;                  // extend pulse for 4 cycles 
        else if (stretch_cnt != 0) 
            stretch_cnt <= stretch_cnt - 1; 
    end 
 
    assign pulse_out = (stretch_cnt != 0);        // output stays high while counter active 
endmodule 