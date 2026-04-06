module gray_to_bin #(
    parameter WIDTH = 8   // Bit width - change to any value
)(
    input  wire [WIDTH-1:0] gray,   // Gray code input
    output wire [WIDTH-1:0] bin     // Binary output
);
    // MSB is always the same
    assign bin[WIDTH-1] = gray[WIDTH-1];

    // Each lower bit: bin[i] = bin[i+1] ^ gray[i]
    genvar i;
    generate
        for (i = WIDTH-2; i >= 0; i = i - 1) begin : g2b
            assign bin[i] = bin[i+1] ^ gray[i];
        end
    endgenerate

endmodule