module tb_sipo_shift_register_4bit;

    reg clk;
    reg rst;
    reg serial_in;
    wire [3:0] parallel_out;

    sipo_shift_register_4bit dut(
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        serial_in = 0;
        #10 rst = 0;
        // Input some data
        #10 serial_in = 1;
        #10 serial_in = 0;
        #10 serial_in = 1;
        #10 serial_in = 0;
        #50 $finish;
    end

    initial begin
        $monitor("Time: %0t, Serial_In: %b, Parallel_Out: %b", $time, serial_in, parallel_out);
    end

endmodule