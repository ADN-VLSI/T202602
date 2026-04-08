module tb_uart_receiver;

logic clk;
logic rst_n;
logic rx;
logic [7:0] data_out;
logic data_valid;

uart_receiver dut (.*);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 0;
    rx = 1;
    #10 rst_n = 1;
    #90;
    send_byte(8'hA5);
    #90;
    send_byte(8'h3C);
    #90;
    $finish;
end

task send_byte(input [7:0] data);
    // start bit
    rx = 0;
    repeat(16) @(posedge clk);
    for (int i = 0; i < 8; i++) begin
        rx = data[i];
        repeat(16) @(posedge clk);
    end
    // stop bit
    rx = 1;
    repeat(16) @(posedge clk);
endtask

logic [7:0] expected;
initial begin
    rst_n = 0;
    rx = 1;
    #10 rst_n = 1;
    #90;
    expected = 8'hA5;
    send_byte(expected);
    @(posedge data_valid);
    if (data_out == expected) $display("Test 1 Pass: Received %h", data_out);
    else $error("Test 1 Fail: Expected %h, Received %h", expected, data_out);
    
    expected = 8'h3C;
    send_byte(expected);
    @(posedge data_valid);
    if (data_out == expected) $display("Test 2 Pass: Received %h", data_out);
    else $error("Test 2 Fail: Expected %h, Received %h", expected, data_out);
    
    $display("All tests completed.");
    $finish;
end

endmodule