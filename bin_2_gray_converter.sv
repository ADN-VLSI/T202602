module bin2gray #(
    parameter N = 4   // Width of the binary input
)(
    input  logic [N-1:0] bin,   // Binary input
    output logic [N-1:0] gray   // Gray code output
);

    // Conversion logic
    always_comb begin
        gray[N-1] = bin[N-1]; // MSB remains the same
        for (int i = N-2; i >= 0; i--) begin
            gray[i] = bin[i+1] ^ bin[i]; // XOR adjacent bits
        end
    end

endmodule