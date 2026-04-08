module prog_counter (
    input clk,reset,load,M,
    input [2:0] preset,
    output reg  [2:0] Q,
    output termi_count
);

    wire TA, TB, TC;

    assign TA = 1'b1;
    assign TB = (~M & Q[0]) | (M & ~Q[0]);
    assign TC = (M & ~Q[1] & ~Q[0]) | (~M & Q[1] & Q[0]);

    always @(posedge clk) begin
        if (reset)
            Q <= 3'b000;
        else if (load)
            Q <= preset;
        else begin
          //next state,q+=t xor q;
            Q[0] <= TA ^ Q[0];
            Q[1] <= TB ^ Q[1];
            Q[2] <= TC ^ Q[2];
        end
    end

  assign termi_count = (~reset & ~load) & 
                       ( (M & (Q == 3'b111)) | (~M & (Q == 3'b000)) );
                        

endmodule