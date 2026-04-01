module tb_parameterized_mux;

    parameter WIDTH1 = 4;
    parameter NUM_INPUTS1 = 2;
    parameter WIDTH2 = 8;
    parameter NUM_INPUTS2 = 4;

    // Instance 1: 2-input 4-bit mux
    reg [WIDTH1-1:0] data_in1 [0:NUM_INPUTS1-1];
    reg [$clog2(NUM_INPUTS1)-1:0] sel1;
    wire [WIDTH1-1:0] data_out1;

    parameterized_mux #(.WIDTH(WIDTH1), .NUM_INPUTS(NUM_INPUTS1)) mux1 (
        .data_in(data_in1),
        .sel(sel1),
        .data_out(data_out1)
    );

    // Instance 2: 4-input 8-bit mux
    reg [WIDTH2-1:0] data_in2 [0:NUM_INPUTS2-1];
    reg [$clog2(NUM_INPUTS2)-1:0] sel2;
    wire [WIDTH2-1:0] data_out2;

    parameterized_mux #(.WIDTH(WIDTH2), .NUM_INPUTS(NUM_INPUTS2)) mux2 (
        .data_in(data_in2),
        .sel(sel2),
        .data_out(data_out2)
    );

    initial begin
        $display("Testing Parameterized MUX");

        // Test instance 1
        data_in1[0] = 4'b1010;
        data_in1[1] = 4'b1100;
        sel1 = 0;
        #10;
        $display("Mux1 (4-bit, 2-input): sel=%d, out=%b (expected: 1010)", sel1, data_out1);
        sel1 = 1;
        #10;
        $display("Mux1 (4-bit, 2-input): sel=%d, out=%b (expected: 1100)", sel1, data_out1);

        // Test instance 2
        data_in2[0] = 8'hAA;
        data_in2[1] = 8'hBB;
        data_in2[2] = 8'hCC;
        data_in2[3] = 8'hDD;
        sel2 = 0;
        #10;
        $display("Mux2 (8-bit, 4-input): sel=%d, out=%h (expected: AA)", sel2, data_out2);
        sel2 = 1;
        #10;
        $display("Mux2 (8-bit, 4-input): sel=%d, out=%h (expected: BB)", sel2, data_out2);
        sel2 = 2;
        #10;
        $display("Mux2 (8-bit, 4-input): sel=%d, out=%h (expected: CC)", sel2, data_out2);
        sel2 = 3;
        #10;
        $display("Mux2 (8-bit, 4-input): sel=%d, out=%h (expected: DD)", sel2, data_out2);

        $finish;
    end

endmodule