module tb_up_counter_3bit;

    reg clk;
    reg rst;
    wire [2:0] count;

    up_counter_3bit dut(
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    initial begin
        $dumpfile("up_counter_3bit.vcd");
        $dumpvars(0, tb_up_counter_3bit);
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #10 rst = 0;
        #90 $finish;
    end

    initial begin
        $monitor("Time: %0t, Count: %b", $time, count);
    end

endmodule