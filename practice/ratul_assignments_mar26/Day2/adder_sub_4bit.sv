module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule

module adder_sub_4bit (
    input [3:0] a,
    input [3:0] b,
    input sub,
    output [3:0] sum,
    output carry_out
);

    wire [3:0] b_inv = sub ? ~b : b;
    wire cin = sub;

    wire c1, c2, c3;

    full_adder fa0 (.a(a[0]), .b(b_inv[0]), .cin(cin), .sum(sum[0]), .cout(c1));
    full_adder fa1 (.a(a[1]), .b(b_inv[1]), .cin(c1), .sum(sum[1]), .cout(c2));
    full_adder fa2 (.a(a[2]), .b(b_inv[2]), .cin(c2), .sum(sum[2]), .cout(c3));
    full_adder fa3 (.a(a[3]), .b(b_inv[3]), .cin(c3), .sum(sum[3]), .cout(carry_out));

endmodule