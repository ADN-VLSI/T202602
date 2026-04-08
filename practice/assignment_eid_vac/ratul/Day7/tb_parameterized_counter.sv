module tb_parameterized_counter;

    parameter WIDTH1 = 3;
    parameter WIDTH2 = 4;

    reg clk, rst, en1, en2;
    wire [WIDTH1-1:0] count1;
    wire [WIDTH2-1:0] count2;

    parameterized_counter #(.WIDTH(WIDTH1)) cnt1 (
        .clk(clk),
        .rst(rst),
        .en(en1),
        .count(count1)
    );

    parameterized_counter #(.WIDTH(WIDTH2)) cnt2 (
        .clk(clk),
        .rst(rst),
        .en(en2),
        .count(count2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Testing Parameterized Counter");

        rst = 1;
        en1 = 0;
        en2 = 0;
        #10;
        rst = 0;
        #10;

        // Test cnt1 (3-bit)
        en1 = 1;
        repeat(10) begin
            #10;
            $display("Cnt1 (3-bit): count=%d", count1);
        end
        en1 = 0;
        #10;
        $display("Cnt1 stopped: count=%d", count1);

        // Reset and test cnt2 (4-bit)
        rst = 1;
        #10;
        rst = 0;
        en2 = 1;
        repeat(20) begin
            #10;
            $display("Cnt2 (4-bit): count=%d", count2);
        end

        $finish;
    end

endmodule