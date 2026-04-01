module tb_mux2to1;
    logic a, b, sel, y;

    mux2to1 dut (.*);

    initial begin
        $monitor("Time=%0t: a=%b, b=%b, sel=%b, y=%b", $time, a, b, sel, y);
        a = 0; b = 0; sel = 0; #10;
        a = 0; b = 1; sel = 0; #10;
        a = 1; b = 0; sel = 0; #10;
        a = 1; b = 1; sel = 0; #10;
        a = 0; b = 0; sel = 1; #10;
        a = 0; b = 1; sel = 1; #10;
        a = 1; b = 0; sel = 1; #10;
        a = 1; b = 1; sel = 1; #10;
        $finish;
    end
endmodule