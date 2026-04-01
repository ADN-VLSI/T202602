module tb_parameterized_shift_register;

    parameter WIDTH1 = 4;
    parameter DIR1 = 0; // left shift
    parameter WIDTH2 = 8;
    parameter DIR2 = 1; // right shift

    reg clk, rst, en1, en2, shift_in1, shift_in2;
    wire [WIDTH1-1:0] data_out1;
    wire [WIDTH2-1:0] data_out2;

    parameterized_shift_register #(.WIDTH(WIDTH1), .DIR(DIR1)) sr1 (
        .clk(clk),
        .rst(rst),
        .en(en1),
        .shift_in(shift_in1),
        .data_out(data_out1)
    );

    parameterized_shift_register #(.WIDTH(WIDTH2), .DIR(DIR2)) sr2 (
        .clk(clk),
        .rst(rst),
        .en(en2),
        .shift_in(shift_in2),
        .data_out(data_out2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Testing Parameterized Shift Register");

        rst = 1;
        en1 = 0;
        en2 = 0;
        shift_in1 = 0;
        shift_in2 = 0;
        #10;
        rst = 0;
        #10;

        // Test sr1 (4-bit left shift)
        en1 = 1;
        shift_in1 = 1;
        #10;
        $display("SR1 (4-bit left): shift_in=%b, data_out=%b", shift_in1, data_out1);
        shift_in1 = 0;
        #10;
        $display("SR1: shift_in=%b, data_out=%b", shift_in1, data_out1);
        shift_in1 = 1;
        #10;
        $display("SR1: shift_in=%b, data_out=%b", shift_in1, data_out1);
        en1 = 0;
        #10;
        $display("SR1 stopped: data_out=%b", data_out1);

        // Test sr2 (8-bit right shift)
        en2 = 1;
        shift_in2 = 1;
        #10;
        $display("SR2 (8-bit right): shift_in=%b, data_out=%b", shift_in2, data_out2);
        shift_in2 = 0;
        #10;
        $display("SR2: shift_in=%b, data_out=%b", shift_in2, data_out2);
        shift_in2 = 1;
        #10;
        $display("SR2: shift_in=%b, data_out=%b", shift_in2, data_out2);

        $finish;
    end

endmodule