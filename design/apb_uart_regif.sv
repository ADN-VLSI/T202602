module apb_uart_regif (
    input  logic        pclk,
    input  logic        presetn,

    // APB signals
    input  logic        psel,
    input  logic        penable,
    input  logic [7:0]  paddr,
    input  logic        pwrite,
    input  logic [31:0] pwdata,
    input  logic [3:0]  pstrb,
    output logic        pready,
    output logic [31:0] prdata,
    output logic        pslverr,

    // UART side signals
    output logic        uart_en,
    output logic        tx_start,
    output logic [7:0]  tx_data,
    input  logic [7:0]  rx_data,
    input  logic        rx_valid,
    input  logic        tx_ready,
    output logic [15:0] baud_div
);

  // Address map
  localparam CTRL_ADDR    = 8'h00;
  localparam STATUS_ADDR  = 8'h04;
  localparam TXDATA_ADDR  = 8'h08;
  localparam RXDATA_ADDR  = 8'h0C;
  localparam BAUDDIV_ADDR = 8'h10;

  // Internal registers
  logic [31:0] ctrl_reg;
  logic [31:0] status_reg;
  logic [31:0] txdata_reg;
  logic [31:0] rxdata_reg;
  logic [31:0] bauddiv_reg;

  // APB valid access
  wire apb_write = psel & penable & pwrite;
  wire apb_read  = psel & penable & (~pwrite);

  // Always ready, no error in this simple model
  assign pready  = 1'b1;
  assign pslverr = 1'b0;

  // Output connections
  assign uart_en  = ctrl_reg[0];
  assign baud_div = bauddiv_reg[15:0];

  // tx_start should be a pulse when TXDATA is written
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn)
      tx_start <= 1'b0;
    else
      tx_start <= (apb_write && (paddr == TXDATA_ADDR));
  end

  // Register write logic
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      ctrl_reg    <= 32'h0000_0000;
      txdata_reg  <= 32'h0000_0000;
      rxdata_reg  <= 32'h0000_0000;
      bauddiv_reg <= 32'd16;   // default baud divider
      tx_data     <= 8'h00;
    end
    else begin
      // Capture RX data when valid
      if (rx_valid)
        rxdata_reg <= {24'h0, rx_data};

      if (apb_write) begin
        case (paddr)
          CTRL_ADDR: begin
            if (pstrb[0]) ctrl_reg[7:0] <= pwdata[7:0];
          end

          TXDATA_ADDR: begin
            if (pstrb[0]) begin
              txdata_reg[7:0] <= pwdata[7:0];
              tx_data         <= pwdata[7:0];
            end
          end

          BAUDDIV_ADDR: begin
            if (pstrb[0]) bauddiv_reg[7:0]   <= pwdata[7:0];
            if (pstrb[1]) bauddiv_reg[15:8]  <= pwdata[15:8];
            if (pstrb[2]) bauddiv_reg[23:16] <= pwdata[23:16];
            if (pstrb[3]) bauddiv_reg[31:24] <= pwdata[31:24];
          end

          default: begin
            // no write
          end
        endcase
      end
    end
  end

  // STATUS register update
  always_comb begin
    status_reg         = 32'h0;
    status_reg[0]      = tx_ready;   // TX ready
    status_reg[1]      = rx_valid;   // RX valid
  end

  // APB read mux
  always_comb begin
    prdata = 32'h0000_0000;

    if (apb_read) begin
      case (paddr)
        CTRL_ADDR:    prdata = ctrl_reg;
        STATUS_ADDR:  prdata = status_reg;
        TXDATA_ADDR:  prdata = txdata_reg;
        RXDATA_ADDR:  prdata = rxdata_reg;
        BAUDDIV_ADDR: prdata = bauddiv_reg;
        default:      prdata = 32'hDEAD_BEEF;
      endcase
    end
  end

endmodule