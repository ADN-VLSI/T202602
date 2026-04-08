module tb_adder_sub_4bit;

    reg [3:0] a, b;
    reg sub;
    wire [3:0] sum;
    wire carry_out;

    adder_sub_4bit dut (
        .a(a),
        .b(b),
        .sub(sub),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        $monitor("Time: %0t | a=%d b=%d sub=%b | sum=%d carry_out=%b", $time, a, b, sub, sum, carry_out);

        // Add
        sub = 0;
        a = 4'd5; b = 4'd3; #10;
        a = 4'd15; b = 4'd1; #10;  // overflow

        // Sub
        sub = 1;
        a = 4'd5; b = 4'd3; #10;
        a = 4'd3; b = 4'd5; #10;  // negative

        $finish;
    end

endmodule