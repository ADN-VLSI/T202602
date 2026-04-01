module tb_bcd_7seg;

    reg [3:0] bcd;
    wire [6:0] seg;

    bcd_7seg dut (
        .bcd(bcd),
        .seg(seg)
    );

    initial begin
        $monitor("Time: %0t | bcd=%d | seg=%b", $time, bcd, seg);

        for (bcd = 0; bcd < 10; bcd = bcd + 1) begin
            #10;
        end

        bcd = 4'd10; #10;  // invalid

        $finish;
    end

endmodule