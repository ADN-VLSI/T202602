module mux_2to1 (
    input a,
    input b,
    input sel,
    output out
);

    assign out = sel ? b : a;

endmodule

module mux_8to1 (
    input [7:0] in,
    input [2:0] sel,
    output out
);

    wire m01, m23, m45, m67, m0123, m4567;

    mux_2to1 mux0 (.a(in[0]), .b(in[1]), .sel(sel[0]), .out(m01));
    mux_2to1 mux1 (.a(in[2]), .b(in[3]), .sel(sel[0]), .out(m23));
    mux_2to1 mux2 (.a(in[4]), .b(in[5]), .sel(sel[0]), .out(m45));
    mux_2to1 mux3 (.a(in[6]), .b(in[7]), .sel(sel[0]), .out(m67));

    mux_2to1 mux4 (.a(m01), .b(m23), .sel(sel[1]), .out(m0123));
    mux_2to1 mux5 (.a(m45), .b(m67), .sel(sel[1]), .out(m4567));

    mux_2to1 mux6 (.a(m0123), .b(m4567), .sel(sel[2]), .out(out));

endmodule