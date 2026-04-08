module tb_gray_to_bin;

    parameter int WIDTH       = 4;
    parameter int NUM_VECTORS = 16;

    logic [WIDTH-1:0] gray;
    logic [WIDTH-1:0] bin;

    // DUT instantiation
    gray_to_bin #(.WIDTH(WIDTH)) dut (
        .gray(gray),
        .bin(bin)
    );

    function automatic logic [WIDTH-1:0] expected_binary(input logic [WIDTH-1:0] gray_in);
        logic [WIDTH-1:0] result;
        result[WIDTH-1] = gray_in[WIDTH-1];
        for (int i = WIDTH-2; i >= 0; i--) begin
            result[i] = result[i+1] ^ gray_in[i];
        end
        return result;
    endfunction

    logic [WIDTH-1:0] test_vectors [NUM_VECTORS];
    integer errors;

    initial begin
        $display("WIDTH=%0d NUM_VECTORS=%0d", WIDTH, NUM_VECTORS);

        for (int i = 0; i < NUM_VECTORS; i++) begin
            test_vectors[i] = i[WIDTH-1:0] ^ (i[WIDTH-1:0] >> 1);
        end

        $display("Time\tGray\tBinary\tExpected\tResult");
        errors = 0;

        for (int i = 0; i < NUM_VECTORS; i++) begin
            gray = test_vectors[i];
            #1;
            logic [WIDTH-1:0] expected = expected_binary(gray);
            if (bin !== expected) begin
                $error("Mismatch at time %0t: gray=%b expected=%b got=%b", $time, gray, expected, bin);
                errors++;
            end else begin
                $display("%0t\t%b\t%b\t%b\tPASS", $time, gray, bin, expected);
            end
            #9;
        end

        if (errors == 0) begin
            $display("PASS: all %0d vectors matched", NUM_VECTORS);
        end else begin
            $display("FAIL: %0d mismatches detected", errors);
        end

        $finish;
    end

endmodule