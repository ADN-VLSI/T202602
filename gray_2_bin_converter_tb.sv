module tb_gray_to_bin;

    parameter WIDTH = 4;
    logic [WIDTH-1:0] gray;
    logic [WIDTH-1:0] bin;

    // DUT instantiation
    gray_to_bin #(WIDTH) dut (
        .gray(gray),
        .bin(bin)
    );

    initial begin
        $display("Time\tGray\tBinary");
        $monitor("%0t\t%b\t%b", $time, gray, bin);

        // Apply test vectors
        gray = 4'b0000; #10;
        gray = 4'b0001; #10;
        gray = 4'b0011; #10;
        gray = 4'b0010; #10;
        gray = 4'b0110; #10;
        gray = 4'b0111; #10;
        gray = 4'b0101; #10;
        gray = 4'b0100; #10;
        gray = 4'b1100; #10;
        gray = 4'b1101; #10;
        gray = 4'b1111; #10;
        gray = 4'b1110; #10;
        gray = 4'b1010; #10;
        gray = 4'b1011; #10;
        gray = 4'b1001; #10;
        gray = 4'b1000; #10;

        $finish;
    end

endmodule