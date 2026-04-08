module tb_mux_8to1;

    reg [7:0] in;
    reg [2:0] sel;
    wire out;

    mux_8to1 dut (
        .in(in),
        .sel(sel),
        .out(out)
    );

    initial begin
        $monitor("Time: %0t | in=%b sel=%d | out=%b", $time, in, sel, out);

        in = 8'b10110001;

        for (sel = 0; sel < 8; sel = sel + 1) begin
            #10;
        end

        $finish;
    end

endmodule