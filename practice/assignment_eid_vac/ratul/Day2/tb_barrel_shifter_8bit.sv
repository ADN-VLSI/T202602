module tb_barrel_shifter_8bit;

    reg [7:0] data;
    reg [2:0] shift;
    reg dir, arith;
    wire [7:0] shifted;

    barrel_shifter_8bit dut (
        .data(data),
        .shift(shift),
        .dir(dir),
        .arith(arith),
        .shifted(shifted)
    );

    initial begin
        $monitor("Time: %0t | data=%b shift=%d dir=%b arith=%b | shifted=%b", $time, data, shift, dir, arith, shifted);

        data = 8'b10110100;

        // Logical left
        dir = 0; arith = 0; shift = 0; #10;
        shift = 1; #10;
        shift = 2; #10;
        shift = 3; #10;

        // Logical right
        dir = 1; arith = 0; shift = 0; #10;
        shift = 1; #10;
        shift = 2; #10;
        shift = 3; #10;

        // Arithmetic right
        dir = 1; arith = 1; shift = 0; #10;
        shift = 1; #10;
        shift = 2; #10;
        shift = 3; #10;

        $finish;
    end

endmodule