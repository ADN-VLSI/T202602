module tb_up_down_counter_3bit;

    reg clk;
    reg rst;
    reg up_down;
    wire [2:0] count;

    up_down_counter_3bit dut(
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
        .count(count)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        up_down = 1;
        #10 rst = 0;
        #40 up_down = 0; // Switch to down after some time
        #40 up_down = 1; // Back to up
        #40 $finish;
    end

    initial begin
        $monitor("Time: %0t, Up_Down: %b, Count: %b", $time, up_down, count);
    end

endmodule