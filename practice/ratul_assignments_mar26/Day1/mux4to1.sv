module mux4to1 (
    input logic [3:0] d,
    input logic [1:0] sel,
    output logic y
);
    assign y = d[sel];
endmodule