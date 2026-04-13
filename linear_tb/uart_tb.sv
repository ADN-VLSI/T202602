module uart_tb;


  // | Register      | Access | Address | Reset Value | Description                                                 |
  // | ------------- | ------ | ------- | ----------- | ----------------------------------------------------------- |
  // | CTRL          | RW     | 0x00    | 0x0         | Control register for clock enable and FIFO flush operations |
  // | CLK_DIV       | RW     | 0x04    | 0x28B0      | Clock divider register for baud rate generation             |
  // | CFG           | RW     | 0x08    | 0x0         | UART configuration register for parity and stop bits        |
  // | TX_FIFO_COUNT | RO     | 0x0C    | 0x0         | Transmit FIFO data count (read-only)                        |
  // | RX_FIFO_COUNT | RO     | 0x10    | 0x0         | Receive FIFO data count (read-only)                         |
  // | TX_DATA       | WO     | 0x14    | 0x0         | Transmit data register (write-only)                         |
  // | RX_DATA       | RO     | 0x18    | 0x0         | Receive data register (read-only)                           |
  // | INTR_CTRL     | RW     | 0x1C    | 0x0         | Interrupt control register                                  |

  localparam int CTRL_ADDR = 'h00;
  localparam int CLK_DIV_ADDR = 'h04;
  localparam int CFG_ADDR = 'h08;
  localparam int TX_FIFO_COUNT_ADDR = 'h0C;
  localparam int RX_FIFO_COUNT_ADDR = 'h10;
  localparam int TX_DATA_ADDR = 'h14;
  localparam int RX_DATA_ADDR = 'h18;
  localparam int INTR_CTRL_ADDR = 'h1C;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNAL DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic irq_tx_almost_full;
  logic irq_rx_almost_full;
  logic irq_rx_parity_error;
  logic irq_rx_valid;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERFACE DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ctrl_if ctrl_intf ();

  apb_if apb_intf (
      .arst_ni(ctrl_intf.arst_ni),
      .clk_i  (ctrl_intf.clk_i)
  );

  uart_if uart_intf ();

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // DUT DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  uart_top dut (
      .arst_ni(ctrl_intf.arst_ni),
      .clk_i(ctrl_intf.clk_i),
      .psel_i(apb_intf.psel),
      .penable_i(apb_intf.penable),
      .paddr_i(apb_intf.paddr),
      .pwrite_i(apb_intf.pwrite),
      .pwdata_i(apb_intf.pwdata),
      .pstrb_i(apb_intf.pstrb),
      .pready_o(apb_intf.pready),
      .prdata_o(apb_intf.prdata),
      .pslverr_o(apb_intf.pslverr),
      .rx_i(uart_intf.tx),
      .tx_o(uart_intf.rx),
      .irq_tx_almost_full(irq_tx_almost_full),
      .irq_rx_almost_full(irq_rx_almost_full),
      .irq_rx_parity_error(irq_rx_parity_error),
      .irq_rx_valid(irq_rx_valid)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURAL BLOCKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    int rdata;

    $timeformat(-6, 0, "us");
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);

    ctrl_intf.apply_reset();
    ctrl_intf.enable_clock();

    apb_intf.read(CLK_DIV_ADDR, rdata);
    $display("CLK_DIV :: 0x%h", rdata);

    $finish;
  end

endmodule
