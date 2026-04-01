module priority_encoder_8to3 (
    input logic [7:0] d,
    output logic [2:0] y,
    output logic valid
);
    always_comb begin
        valid = |d;
        if (d[7]) y = 3'b111;
        else if (d[6]) y = 3'b110;
        else if (d[5]) y = 3'b101;
        else if (d[4]) y = 3'b100;
        else if (d[3]) y = 3'b011;
        else if (d[2]) y = 3'b010;
        else if (d[1]) y = 3'b001;
        else y = 3'b000;
    end
endmodule