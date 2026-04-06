module bin2gray_tb #(parameter int N = 4);

    logic [N-1:0] bin;
    logic [N-1:0] gray;
    logic [N-1:0] expected_gray;

    // DUT instantiation with parameterized width
    bin2gray #(.N(N)) dut (
        .bin(bin),
        .gray(gray)
    );

    // Function to compute binary-to-Gray conversion for comparison
    function automatic logic [N-1:0] compute_gray(logic [N-1:0] value);
        compute_gray[N-1] = value[N-1];
        for (int i = N-2; i >= 0; i--) begin
            compute_gray[i] = value[i+1] ^ value[i];
        end
    endfunction

    initial begin
        int unsigned error_count = 0;
        int unsigned test_count = 0;

        $display("%%0t: Starting bin2gray self-checking testbench for N=%0d", $time, N);

        for (int unsigned i = 0; i < (1 << N); i++) begin
            bin = i;
            #1; // allow combinational logic to settle

            expected_gray = compute_gray(bin);
            test_count++;

            if (gray !== expected_gray) begin
                error_count++;
                $error("Mismatch: bin=%0b expected=%0b got=%0b", bin, expected_gray, gray);
            end
            else begin
                $display("PASS: bin=%0b gray=%0b", bin, gray);
            end
        end

        if (error_count == 0) begin
            $display("TEST PASSED: %0d patterns checked for N=%0d", test_count, N);
        end else begin
            $fatal("TEST FAILED: %0d mismatches for N=%0d", error_count, N);
        end

        $finish;
    end

endmodule

  