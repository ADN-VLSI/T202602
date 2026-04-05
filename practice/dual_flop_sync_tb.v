module dual_flop_sync_tb;

  logic clk;
  logic rst_n;
  logic async_in;
  logic sync_out;

  // Instantiate DUT
  dual_flop_sync dut (
    .clk(clk),
    .rst_n(rst_n),
    .async_in(async_in),
    .sync_out(sync_out)
  );

  // Clock generation (10ns period)
  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    // Initialize signals
    clk = 0;
    rst_n = 0;
    async_in = 0;

    // Apply reset
    #12;
    rst_n = 1;

    // Apply asynchronous input changes (not aligned to clock)
    #7  async_in = 1;   // random time
    #13 async_in = 0;
    #9  async_in = 1;
    #11 async_in = 0;

    #20;
    $finish;
  end
endmodule