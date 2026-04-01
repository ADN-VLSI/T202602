module decoder_3to8 (
    input logic [2:0] sel,
    input logic en,
    output logic [7:0] y
);
    assign y = en ? (1 << sel) : 8'b00000000;
endmodule