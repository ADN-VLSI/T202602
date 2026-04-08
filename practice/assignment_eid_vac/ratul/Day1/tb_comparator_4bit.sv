module tb_comparator_4bit;
    logic [3:0] a, b;
    logic eq, gt, lt;

    comparator_4bit dut (.*);

    initial begin
        $monitor("Time=%0t: a=%b (%0d), b=%b (%0d), eq=%b, gt=%b, lt=%b", $time, a, a, b, b, eq, gt, lt);
        a = 4'b0000; b = 4'b0000; #10;
        a = 4'b0001; b = 4'b0000; #10;
        a = 4'b0000; b = 4'b0001; #10;
        a = 4'b0101; b = 4'b0101; #10;
        a = 4'b1111; b = 4'b0111; #10;
        $finish;
    end
endmodule