module parameterized_mux #(parameter WIDTH = 8, parameter NUM_INPUTS = 4) (
    input [WIDTH-1:0] data_in [0:NUM_INPUTS-1],
    input [$clog2(NUM_INPUTS)-1:0] sel,
    output [WIDTH-1:0] data_out
);

    assign data_out = data_in[sel];

endmodule