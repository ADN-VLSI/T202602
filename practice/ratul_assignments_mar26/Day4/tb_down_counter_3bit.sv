module tb_down_counter_3bit;

    reg clk;
    reg rst;
    wire [2:0] count;

    down_counter_3bit dut(
        .clk(clk),
        .rst(rst),
        .count(count)
    );

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