module tb_decoder_3to8;
    logic [2:0] sel;
    logic en;
    logic [7:0] y;

    decoder_3to8 dut (.*);

    initial begin
        $monitor("Time=%0t: sel=%b (%0d), en=%b, y=%b", $time, sel, sel, en, y);
        en = 1;
        for (int i = 0; i < 8; i++) begin
            sel = i;
            #10;
        end
        en = 0; sel = 3'b000; #10;
        $finish;
    end
endmodule