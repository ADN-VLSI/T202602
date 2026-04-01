module tb_demux1to2;
    logic d, sel, y0, y1;

    demux1to2 dut (.*);

    initial begin
        $monitor("Time=%0t: d=%b, sel=%b, y0=%b, y1=%b", $time, d, sel, y0, y1);
        d = 0; sel = 0; #10;
        d = 1; sel = 0; #10;
        d = 0; sel = 1; #10;
        d = 1; sel = 1; #10;
        $finish;
    end
endmodule