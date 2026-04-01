module tb_encoder_8to3;
    logic [7:0] d;
    logic [2:0] y;
    logic valid;

    encoder_8to3 dut (.*);

    initial begin
        $monitor("Time=%0t: d=%b, y=%b (%0d), valid=%b", $time, d, y, y, valid);
        for (int i = 0; i < 8; i++) begin
            d = 1 << i;
            #10;
        end
        d = 8'b00000000; #10;
        d = 8'b00000011; #10;
        $finish;
    end
endmodule