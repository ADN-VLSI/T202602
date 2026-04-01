module tb_mod10_counter;

    reg clk;
    reg rst;
    wire [3:0] count;

    mod10_counter dut(
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
        #90 $finish; // More cycles for mod10
    end

    initial begin
        $monitor("Time: %0t, Count: %d", $time, count);
    end

endmodule