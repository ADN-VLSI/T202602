module tb_apb_uart_regif;

  logic        pclk;
  logic        presetn;

  logic        psel;
  logic        penable;
  logic [7:0]  paddr;
  logic        pwrite;
  logic [31:0] pwdata;
  logic [3:0]  pstrb;
  logic        pready;
  logic [31:0] prdata;
  logic        pslverr;

  logic        uart_en;
  logic        tx_start;
  logic [7:0]  tx_data;
  logic [7:0]  rx_data;
  logic        rx_valid;
  logic        tx_ready;
  logic [15:0] baud_div;

  // DUT
  apb_uart_regif dut (
    .pclk(pclk),
    .presetn(presetn),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .pstrb(pstrb),
    .pready(pready),
    .prdata(prdata),
    .pslverr(pslverr),
    .uart_en(uart_en),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .tx_ready(tx_ready),
    .baud_div(baud_div)
  );

  // Clock
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  // APB write task
  task apb_write(input [7:0] addr, input [31:0] data);
    begin
      @(posedge pclk);
      psel    <= 1'b1;
      penable <= 1'b0;
      paddr   <= addr;
      pwrite  <= 1'b1;
      pwdata  <= data;
      pstrb   <= 4'hF;

      @(posedge pclk);
      penable <= 1'b1;

      @(posedge pclk);
      psel    <= 1'b0;
      penable <= 1'b0;
      pwrite  <= 1'b0;
      paddr   <= 8'h00;
      pwdata  <= 32'h0;
    end
  endtask

  // APB read task
  task apb_read(input [7:0] addr, output [31:0] data);
    begin
      @(posedge pclk);
      psel    <= 1'b1;
      penable <= 1'b0;
      paddr   <= addr;
      pwrite  <= 1'b0;
      pstrb   <= 4'h0;

      @(posedge pclk);
      penable <= 1'b1;

      @(posedge pclk);
      data = prdata;

      psel    <= 1'b0;
      penable <= 1'b0;
      paddr   <= 8'h00;
    end
  endtask

  logic [31:0] rdata;

  initial begin
    $display("=== APB UART REGIF TEST START ===");

    // init
    presetn = 0;
    psel    = 0;
    penable = 0;
    paddr   = 0;
    pwrite  = 0;
    pwdata  = 0;
    pstrb   = 0;

    rx_data  = 8'h00;
    rx_valid = 1'b0;
    tx_ready = 1'b1;

    #20;
    presetn = 1;

    // Write CTRL (enable UART)
    apb_write(8'h00, 32'h0000_0001);
    $display("CTRL written, uart_en = %0d", uart_en);

    // Write BAUDDIV
    apb_write(8'h10, 32'd52);
    $display("BAUDDIV written, baud_div = %0d", baud_div);

    // Write TXDATA
    apb_write(8'h08, 32'h0000_00A5);
    $display("TXDATA written, tx_data = 0x%0h, tx_start = %0d", tx_data, tx_start);

    // Read STATUS
    apb_read(8'h04, rdata);
    $display("STATUS read = 0x%08h", rdata);

    // Simulate RX valid
    @(posedge pclk);
    rx_data  <= 8'h3C;
    rx_valid <= 1'b1;

    @(posedge pclk);
    rx_valid <= 1'b0;

    // Read RXDATA
    apb_read(8'h0C, rdata);
    $display("RXDATA read = 0x%08h", rdata);

    #20;
    $display("=== TEST END ===");
    $finish;
  end

endmodule