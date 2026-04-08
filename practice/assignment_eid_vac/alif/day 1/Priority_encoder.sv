///7) Priority Encoder (8:3) 
///RTL 
module priority_encoder8to3( 
    input  logic [7:0] d, 
    output logic [2:0] y, 
    output logic valid 
); 
    always_comb begin 
        valid = 1'b1; 
        casex(d) 
            8'b1xxxxxxx: y = 3'd7; 
            8'b01xxxxxx: y = 3'd6; 
            8'b001xxxxx: y = 3'd5; 
            8'b0001xxxx: y = 3'd4; 
            8'b00001xxx: y = 3'd3; 
            8'b000001xx: y = 3'd2; 
            8'b0000001x: y = 3'd1; 
            8'b00000001: y = 3'd0; 
            default: begin 
                y = 3'd0; 
                valid = 1'b0; 
            end 
        endcase 
    end 
endmodule