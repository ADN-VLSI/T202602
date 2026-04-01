module tb_parameterized_register;

    parameter WIDTH1 = 4;
    parameter WIDTH2 = 8;

    reg clk, rst, en1, en2;
    reg [WIDTH1-1:0] d1;
    reg [WIDTH2-1:0] d2;
    wire [WIDTH1-1:0] q1;
    wire [WIDTH2-1:0] q2;

    parameterized_register #(.WIDTH(WIDTH1)) reg1 (
        .clk(clk),
        .rst(rst),
        .en(en1),
        .d(d1),
        .q(q1)
    );

    parameterized_register #(.WIDTH(WIDTH2)) reg2 (
        .clk(clk),
        .rst(rst),
        .en(en2),
        .d(d2),
        .q(q2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Testing Parameterized Register");

        rst = 1;
        en1 = 0;
        en2 = 0;
        d1 = 0;
        d2 = 0;
        #10;
        rst = 0;
        #10;

        // Test reg1 (4-bit)
        d1 = 4'b1010;
        en1 = 1;
        #10;
        $display("Reg1 (4-bit): d=%b, q=%b (expected: 1010)", d1, q1);
        en1 = 0;
        d1 = 4'b1111;
        #10;
        $display("Reg1 (4-bit): en=0, q=%b (should hold 1010)", q1);

        // Test reg2 (8-bit)
        d2 = 8'hAA;
        en2 = 1;
        #10;
        $display("Reg2 (8-bit): d=%h, q=%h (expected: AA)", d2, q2);
        en2 = 0;
        d2 = 8'hFF;
        #10;
        $display("Reg2 (8-bit): en=0, q=%h (should hold AA)", q2);

        // Test reset
        rst = 1;
        #10;
        $display("After reset: Reg1 q=%b, Reg2 q=%h (expected: 0)", q1, q2);

        $finish;
    end

endmodule