module tb_comparator_4bit;

    reg [3:0] a, b;
    wire gt, lt, eq;

    comparator_4bit dut (
        .a(a),
        .b(b),
        .gt(gt),
        .lt(lt),
        .eq(eq)
    );

    initial begin
        $monitor("Time: %0t | a=%d b=%d | gt=%b lt=%b eq=%b", $time, a, b, gt, lt, eq);

        a = 4'd5; b = 4'd3; #10;
        a = 4'd3; b = 4'd5; #10;
        a = 4'd7; b = 4'd7; #10;
        a = 4'd0; b = 4'd15; #10;
        a = 4'd15; b = 4'd0; #10;

        $finish;
    end

endmodule