`timescale 1ns/1ps

module tb_apb_uart_top;

  // Clock / reset
  logic clk;
  logic rst_n;

  // APB signals
  logic        psel;
  logic        penable;
  logic [7:0]  paddr;
  logic        pwrite;
  logic [31:0] pwdata;
  logic [3:0]  pstrb;
  logic        pready;
  logic [31:0] prdata;
  logic        pslverr;

  // UART pins
  logic rx;
  logic tx;

  // Test variable
  logic [31:0] received;

  // DUT
  apb_uart_top dut (
    .clk(clk),
    .rst_n(rst_n),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .pstrb(pstrb),
    .pready(pready),
    .prdata(prdata),
    .pslverr(pslverr),
    .rx(rx),
    .tx(tx)
  );

  // Loopback TX -> RX
  assign rx = tx;

  // Clock generation: 50 MHz
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // APB write task
  task automatic apb_write(input logic [7:0] addr, input logic [31:0] data);
    begin
      @(posedge clk);
      psel    <= 1'b1;
      penable <= 1'b0;
      paddr   <= addr;
      pwrite  <= 1'b1;
      pwdata  <= data;
      pstrb   <= 4'hF;

      @(posedge clk);
      penable <= 1'b1;

      while (!pready) @(posedge clk);

      @(posedge clk);
      psel    <= 1'b0;
      penable <= 1'b0;
      pwrite  <= 1'b0;
      paddr   <= 8'h00;
      pwdata  <= 32'h0;
      pstrb   <= 4'h0;
    end
  endtask

  // APB read task
  task automatic apb_read(input logic [7:0] addr, output logic [31:0] data);
    begin
      @(posedge clk);
      psel    <= 1'b1;
      penable <= 1'b0;
      paddr   <= addr;
      pwrite  <= 1'b0;
      pwdata  <= 32'h0;
      pstrb   <= 4'h0;

      @(posedge clk);
      penable <= 1'b1;

      while (!pready) @(posedge clk);

      data = prdata;

      @(posedge clk);
      psel    <= 1'b0;
      penable <= 1'b0;
      paddr   <= 8'h00;
    end
  endtask

  // Poll STATUS until RX valid is asserted
  task automatic wait_for_rx_valid();
    logic [31:0] status_value;
    begin
      status_value = 32'h0;
      repeat (100) begin
        apb_read(8'h04, status_value);
        if (status_value[1]) begin
          return;
        end
      end
    end
  endtask

  initial begin
    $display("=== tb_apb_uart_top START ===");

    // Initialize signals
    rst_n    = 1'b0;
    psel     = 1'b0;
    penable  = 1'b0;
    paddr    = 8'h00;
    pwrite   = 1'b0;
    pwdata   = 32'h0;
    pstrb    = 4'h0;

    #50;
    rst_n = 1'b1;
    #50;

    // Enable UART
    apb_write(8'h00, 32'h0000_0001);
    $display("%0t: UART enabled", $time);

    // Set baud divider to 16 for a short loopback transaction
    apb_write(8'h10, 32'd16);
    $display("%0t: Baud divider set", $time);

    // Send byte A5 over UART
    apb_write(8'h08, 32'h0000_00A5);
    $display("%0t: TXDATA written 0xA5", $time);

    // Wait until receiver has captured data
    wait_for_rx_valid();

    // Read RXDATA register
    apb_read(8'h0C, received);
    $display("%0t: RXDATA read = 0x%08h", $time, received);

    // Send second byte 3C to verify multiple transfers
    apb_write(8'h08, 32'h0000_003C);
    $display("%0t: TXDATA written 0x3C", $time);

    wait_for_rx_valid();
    apb_read(8'h0C, received);
    $display("%0t: RXDATA read = 0x%08h", $time, received);

    #1000;
    $display("=== tb_apb_uart_top END ===");
    $finish;
  end

endmodule
