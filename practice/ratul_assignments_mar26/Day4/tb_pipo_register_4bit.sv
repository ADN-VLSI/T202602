module tb_pipo_register_4bit;

    reg clk;
    reg rst;
    reg [3:0] parallel_in;
    wire [3:0] parallel_out;

    pipo_register_4bit dut(
        .clk(clk),
        .rst(rst),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        parallel_in = 4'b0000;
        #10 rst = 0;
        #10 parallel_in = 4'b1010;
        #10 parallel_in = 4'b0101;
        #10 parallel_in = 4'b1111;
        #20 $finish;
    end

    initial begin
        $monitor("Time: %0t, Parallel_In: %b, Parallel_Out: %b", $time, parallel_in, parallel_out);
    end

endmodule