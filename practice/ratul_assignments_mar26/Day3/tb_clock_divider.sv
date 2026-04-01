module tb_clock_divider;

    logic clk;
    logic rst;
    logic [1:0] divide_select;
    logic clk_div;

    // Instantiate DUT
    clock_divider dut (
        .clk(clk),
        .rst(rst),
        .divide_select(divide_select),
        .clk_div(clk_div)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period
    end

    // Test sequence
    initial begin
        rst = 1;
        divide_select = 2'b00;
        #10 rst = 0;

        // Test /2
        divide_select = 2'b00;
        #90;

        // Test /4
        divide_select = 2'b01;
        #90;

        // Test /3
        divide_select = 2'b10;
        #90;

        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time: %0t, clk: %b, rst: %b, select: %b, clk_div: %b", $time, clk, rst, divide_select, clk_div);
    end

endmodule