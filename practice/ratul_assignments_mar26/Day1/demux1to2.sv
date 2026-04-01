module demux1to2 (
    input logic d, sel,
    output logic y0, y1
);
    assign y0 = ~sel & d;
    assign y1 = sel & d;
endmodule