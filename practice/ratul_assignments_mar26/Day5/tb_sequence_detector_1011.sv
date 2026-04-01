module tb_sequence_detector_1011;

    logic clk;
    logic rst;
    logic in;
    logic out;

    sequence_detector_1011 dut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        in = 0;
        #10 rst = 0;

        // Test sequence: 1 0 1 1 0 1 0 1 1
        // Expected out: 0 0 0 1 0 0 0 0 1
        #10 in = 1; //1
        #10 in = 0; //2
        #10 in = 1; //3
        #10 in = 1; //4 -> out=1
        #10 in = 0; //5
        #10 in = 1; //6
        #10 in = 0; //7
        #10 in = 1; //8
        #10 in = 1; //9 -> out=1
        #10;

        $finish;
    end

    initial begin
        $monitor("Time: %0t, in: %b, out: %b", $time, in, out);
    end

endmodule