module protocol_cvtr_sabbir #(
    parameter int ADDR_WIDTH = 8,
    parameter int DATA_WIDTH = 32
) (

    input  logic arst_ni,
    input  logic clk_i,

    // Custom Protocol - Control Channel
    input  logic [ADDR_WIDTH-1:0] c_addr_i,
    input  logic                  c_wenable_i,
    input  logic                  c_valid_i,
    output logic                  c_ready_o,

    // Write Data Channel
    input  logic [DATA_WIDTH-1:0]     w_data_i,
    input  logic [DATA_WIDTH/8-1:0]   w_strb_i,
    input  logic                     w_valid_i,
    output logic                     w_ready_o,

    // Read Data Channel
    output logic [DATA_WIDTH-1:0] r_data_o,
    output logic                  r_valid_o,
    input  logic                  r_ready_i,

    // Response Channel
    output logic b_slverr_o,
    output logic b_valid_o,
    input  logic b_ready_i,

    // APB Interface
    output logic                    psel_o,
    output logic                    penable_o,
    output logic [ADDR_WIDTH-1:0]   paddr_o,
    output logic                    pwrite_o,
    output logic [DATA_WIDTH-1:0]   pwdata_o,
    output logic [DATA_WIDTH/8-1:0] pstrb_o,

    input  logic                    pready_i,
    input  logic [DATA_WIDTH-1:0]   prdata_i,
    input  logic                    pslverr_i
);

  ////////////////////////////////////////////////////////////////////////////////
  // FSM States
  ////////////////////////////////////////////////////////////////////////////////

  typedef enum logic [2:0] {
    GET_C,
    GET_W,
    APB_SEL,
    APB_EN,
    SEND_R,
    SEND_B
  } state_t;

  state_t current_state, next_state;

  ////////////////////////////////////////////////////////////////////////////////
  // Internal Registers (IMPORTANT FIX)
  ////////////////////////////////////////////////////////////////////////////////

  logic [ADDR_WIDTH-1:0]   addr_q;
  logic                    wenable_q;
  logic [DATA_WIDTH-1:0]   wdata_q;
  logic [DATA_WIDTH/8-1:0] wstrb_q;

  logic [DATA_WIDTH-1:0]   rdata_q;
  logic                    slverr_q;

  ////////////////////////////////////////////////////////////////////////////////
  // Combinational FSM
  ////////////////////////////////////////////////////////////////////////////////

  always_comb begin

    // Default assignments
    next_state   = current_state;

    c_ready_o    = 1'b0;
    w_ready_o    = 1'b0;
    r_valid_o    = 1'b0;
    b_valid_o    = 1'b0;

    psel_o       = 1'b0;
    penable_o    = 1'b0;

    b_slverr_o   = slverr_q;
    r_data_o     = rdata_q;

    case (current_state)

      /////////////////////////////////////////////////////////////
      GET_C
      /////////////////////////////////////////////////////////////
      GET_C: begin
        c_ready_o = 1'b1;

        if (c_valid_i) begin
          if (c_wenable_i)
            next_state = GET_W;
          else
            next_state = APB_SEL;
        end
      end

      /////////////////////////////////////////////////////////////
      GET_W
      /////////////////////////////////////////////////////////////
      GET_W: begin
        w_ready_o = 1'b1;

        if (w_valid_i)
          next_state = APB_SEL;
      end

      /////////////////////////////////////////////////////////////
      APB Setup
      /////////////////////////////////////////////////////////////
      APB_SEL: begin
        psel_o    = 1'b1;
        penable_o = 1'b0;
        next_state = APB_EN;
      end

      /////////////////////////////////////////////////////////////
      APB Enable
      /////////////////////////////////////////////////////////////
      APB_EN: begin
        psel_o    = 1'b1;
        penable_o = 1'b1;

        if (pready_i) begin
          if (wenable_q)
            next_state = SEND_B;
          else
            next_state = SEND_R;
        end
      end

      /////////////////////////////////////////////////////////////
      SEND READ DATA
      /////////////////////////////////////////////////////////////
      SEND_R: begin
        r_valid_o = 1'b1;

        if (r_ready_i)
          next_state = SEND_B;
      end

      /////////////////////////////////////////////////////////////
      SEND RESPONSE
      /////////////////////////////////////////////////////////////
      SEND_B: begin
        b_valid_o = 1'b1;

        if (b_ready_i)
          next_state = GET_C;
      end

    endcase
  end

  ////////////////////////////////////////////////////////////////////////////////
  // Sequential Logic
  ////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (!arst_ni) begin
      current_state <= GET_C;
      addr_q        <= '0;
      wenable_q     <= 1'b0;
      wdata_q       <= '0;
      wstrb_q       <= '0;
      rdata_q       <= '0;
      slverr_q      <= 1'b0;
    end
    else begin
      current_state <= next_state;

      // Latch control info
      if (current_state == GET_C && c_valid_i && c_ready_o) begin
        addr_q    <= c_addr_i;
        wenable_q <= c_wenable_i;
      end

      // Latch write data
      if (current_state == GET_W && w_valid_i && w_ready_o) begin
        wdata_q <= w_data_i;
        wstrb_q <= w_strb_i;
      end

      // Latch APB read data and error
      if (current_state == APB_EN && pready_i) begin
        rdata_q  <= prdata_i;
        slverr_q <= pslverr_i;
      end
    end
  end

  ////////////////////////////////////////////////////////////////////////////////
  // APB Outputs Driven From Registers (STABLE)
  ////////////////////////////////////////////////////////////////////////////////

  assign paddr_o  = addr_q;
  assign pwrite_o = wenable_q;
  assign pwdata_o = wdata_q;
  assign pstrb_o  = wstrb_q;

endmodule