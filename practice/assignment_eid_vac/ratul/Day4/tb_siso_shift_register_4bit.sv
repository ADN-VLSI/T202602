module tb_siso_shift_register_4bit;

    reg clk;
    reg rst;
    reg serial_in;
    wire serial_out;

    siso_shift_register_4bit dut(
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .serial_out(serial_out)
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
        $monitor("Time: %0t, Serial_In: %b, Serial_Out: %b", $time, serial_in, serial_out);
    end

endmodule