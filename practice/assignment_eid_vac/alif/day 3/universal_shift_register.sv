///1) Universal Shift Register 
module universal_shift_register ( 
    input  logic       clk, 
    input  logic       rst, 
    input  logic [1:0] mode,      // 00=hold, 01=shift right, 10=shift left, 11=parallel load 
    input  logic       serial_in, 
    input  logic [3:0] parallel_in, 
    output logic [3:0] q 
); 
    always_ff @(posedge clk) begin 
        if (rst) 
            q <= 4'b0000;                         // synchronous reset 
        else begin 
            case (mode) 
                2'b00: q <= q;                   // hold previous value 
                2'b01: q <= {serial_in, q[3:1]};// shift right 
                2'b10: q <= {q[2:0], serial_in};// shift left 
                2'b11: q <= parallel_in;         // parallel load 
            endcase 
        end 
    end 
endmodule 