module tb_dual_port_mem;

  // Parameters
  parameter ADDR_WIDTH = 4;
  parameter DATA_WIDTH = 8;
  parameter DEPTH      = 1 << ADDR_WIDTH;

  // DUT signals
  logic                  clk;
  logic                  we_a, we_b;
  logic [ADDR_WIDTH-1:0] addr_a, addr_b;
  logic [DATA_WIDTH-1:0] din_a, din_b;
  logic [DATA_WIDTH-1:0] dout_a, dout_b;

  // Instantiate DUT
  dual_port_mem #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .clk(clk),
    .we_a(we_a),
    .addr_a(addr_a),
    .din_a(din_a),
    .dout_a(dout_a),
    .we_b(we_b),
    .addr_b(addr_b),
    .din_b(din_b),
    .dout_b(dout_b)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Test sequence
  initial begin
    // Initialize
    we_a = 0; we_b = 0;
    addr_a = 0; addr_b = 0;
    din_a = 0; din_b = 0;

    // Write to port A
    @(posedge clk);
    we_a   = 1;
    addr_a = 4'h3;
    din_a  = 8'hAA;

    @(posedge clk);
    we_a = 0;

    // Read from port B (same address)
    @(posedge clk);
    addr_b = 4'h3;
    we_b   = 0;

    @(posedge clk);
    $display("Read from Port B: %h (expected AA)", dout_b);

    // Write to port B
    @(posedge clk);
    we_b   = 1;
    addr_b = 4'h5;
    din_b  = 8'h55;

    @(posedge clk);
    we_b = 0;

    // Read from port A (same address)
    @(posedge clk);
    addr_a = 4'h5;

    @(posedge clk);
    $display("Read from Port A: %h (expected 55)", dout_a);

    // Finish
    #20;
    $finish;
  end

endmodule