module tb_priority_encoder_8to3;
    logic [7:0] d;
    logic [2:0] y;
    logic valid;

    priority_encoder_8to3 dut (.*);

    initial begin
        $monitor("Time=%0t: d=%b, y=%b (%0d), valid=%b", $time, d, y, y, valid);
        d = 8'b00000001; #10;
        d = 8'b00000010; #10;
        d = 8'b00000100; #10;
        d = 8'b10000000; #10;
        d = 8'b11000000; #10;
        d = 8'b00000000; #10;
        $finish;
    end
endmodule