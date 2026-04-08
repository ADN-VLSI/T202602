module tb_ring_counter_4bit;

    reg clk;
    reg rst;
    wire [3:0] count;

    ring_counter_4bit dut(
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
        #0 $finish;
    end

    initial begin
        $monitor("Time: %0t, Count: %b", $time, count);
    end

endmodule