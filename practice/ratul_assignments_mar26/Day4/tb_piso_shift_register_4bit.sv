module tb_piso_shift_register_4bit;

    reg clk;
    reg rst;
    reg load;
    reg [3:0] parallel_in;
    wire serial_out;

    piso_shift_register_4bit dut(
        .clk(clk),
        .rst(rst),
        .load(load),
        .parallel_in(parallel_in),
        .serial_out(serial_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        load = 0;
        parallel_in = 4'b1010;
        #10 rst = 0;
        #10 load = 1;
        #10 load = 0;
        #50 $finish;
    end

    initial begin
        $monitor("Time: %0t, Load: %b, Parallel_In: %b, Serial_Out: %b", $time, load, parallel_in, serial_out);
    end

endmodule