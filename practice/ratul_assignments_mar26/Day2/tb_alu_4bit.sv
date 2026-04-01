module tb_alu_4bit;

    reg [3:0] a, b;
    reg [2:0] op;
    wire [3:0] result;
    wire zero, carry;

    alu_4bit dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    initial begin
        $monitor("Time: %0t | a=%b b=%b op=%b | result=%b zero=%b carry=%b", $time, a, b, op, result, zero, carry);

        // Test add
        a = 4'b0010; b = 4'b0001; op = 3'b000; #10;
        a = 4'b1111; b = 4'b0001; op = 3'b000; #10;  // carry

        // Test sub
        a = 4'b0010; b = 4'b0001; op = 3'b001; #10;
        a = 4'b0001; b = 4'b0010; op = 3'b001; #10;  // borrow

        // Test AND
        a = 4'b1010; b = 4'b1100; op = 3'b010; #10;

        // Test OR
        a = 4'b1010; b = 4'b1100; op = 3'b011; #10;

        // Test XOR
        a = 4'b1010; b = 4'b1100; op = 3'b100; #10;

        // Test compare (sub)
        a = 4'b0010; b = 4'b0010; op = 3'b101; #10;  // equal
        a = 4'b0011; b = 4'b0010; op = 3'b101; #10;  // greater
        a = 4'b0001; b = 4'b0010; op = 3'b101; #10;  // less

        $finish;
    end

endmodule