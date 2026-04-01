module tb_parameterized_alu;

    parameter WIDTH1 = 4;
    parameter WIDTH2 = 8;

    reg [WIDTH1-1:0] a1, b1;
    reg [2:0] op1;
    wire [WIDTH1-1:0] result1;
    wire zero1, carry1;

    parameterized_alu #(.WIDTH(WIDTH1)) alu1 (
        .a(a1),
        .b(b1),
        .op(op1),
        .result(result1),
        .zero(zero1),
        .carry(carry1)
    );

    reg [WIDTH2-1:0] a2, b2;
    reg [2:0] op2;
    wire [WIDTH2-1:0] result2;
    wire zero2, carry2;

    parameterized_alu #(.WIDTH(WIDTH2)) alu2 (
        .a(a2),
        .b(b2),
        .op(op2),
        .result(result2),
        .zero(zero2),
        .carry(carry2)
    );

    initial begin
        $display("Testing Parameterized ALU");

        // Test alu1 (4-bit)
        a1 = 4'b1010;
        b1 = 4'b0101;
        op1 = 0; // add
        #10;
        $display("ALU1 (4-bit) add: a=%b, b=%b, result=%b, carry=%b, zero=%b", a1, b1, result1, carry1, zero1);
        op1 = 1; // sub
        #10;
        $display("ALU1 sub: result=%b, carry=%b, zero=%b", result1, carry1, zero1);
        op1 = 2; // and
        #10;
        $display("ALU1 and: result=%b, zero=%b", result1, zero1);
        op1 = 3; // or
        #10;
        $display("ALU1 or: result=%b, zero=%b", result1, zero1);
        op1 = 4; // xor
        #10;
        $display("ALU1 xor: result=%b, zero=%b", result1, zero1);

        // Test alu2 (8-bit)
        a2 = 8'hAA;
        b2 = 8'h55;
        op2 = 0; // add
        #10;
        $display("ALU2 (8-bit) add: a=%h, b=%h, result=%h, carry=%b, zero=%b", a2, b2, result2, carry2, zero2);
        op2 = 1; // sub
        #10;
        $display("ALU2 sub: result=%h, carry=%b, zero=%b", result2, carry2, zero2);
        op2 = 2; // and
        #10;
        $display("ALU2 and: result=%h, zero=%b", result2, zero2);
        op2 = 3; // or
        #10;
        $display("ALU2 or: result=%h, zero=%b", result2, zero2);
        op2 = 4; // xor
        #10;
        $display("ALU2 xor: result=%h, zero=%b", result2, zero2);

        $finish;
    end

endmodule