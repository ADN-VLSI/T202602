module protocol_cvtr #(
    parameter int ADDR_WIDTH = 8,  // Address width for APB
    parameter int DATA_WIDTH = 32  // Data width for APB
) (

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Global Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    input logic arst_ni,  // active-low asynchronous reset
    input logic clk_i,    // clock input

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Custom Protocol Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Control Channel
    input  logic [ADDR_WIDTH-1:0] c_addr_i,     // Control Channel Address input
    input  logic                  c_wenable_i,  // Control Channel Write Enable input
    input  logic                  c_valid_i,    // Control Channel Valid input
    output logic                  c_ready_o,    // Control Channel Ready output

    // Write Data Channel
    input  logic [  DATA_WIDTH-1:0] w_data_i,   // Write Data input
    input  logic [DATA_WIDTH/8-1:0] w_strb_i,   // Write Strobe input (1 bit per byte lane)
    input  logic                    w_valid_i,  // Write Data Valid input
    output logic                    w_ready_o,  // Write Data Ready output

    // Read Data Channel
    output logic [DATA_WIDTH-1:0] r_data_o,   // Read Data output
    output logic                  r_valid_o,  // Read Data Valid output
    input  logic                  r_ready_i,  // Read Data Ready input

    // Response Channel
    output logic b_slverr_o,  // Response Slave Error output
    output logic b_valid_o,   // Response Valid output
    input  logic b_ready_i,   // Response Ready input

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // APB Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // APB Output Signals (to APB Slave)
    output logic                    psel_o,     // APB Select output
    output logic                    penable_o,  // APB Enable output
    output logic [  ADDR_WIDTH-1:0] paddr_o,    // APB Address output
    output logic                    pwrite_o,   // APB Write output
    output logic [  DATA_WIDTH-1:0] pwdata_o,   // APB Write Data output
    output logic [DATA_WIDTH/8-1:0] pstrb_o,    // APB Write Strobe output (1 bit per byte lane)

    // APB Input Signals (from APB Slave)
    input logic                  pready_i,  // APB Ready input
    input logic [DATA_WIDTH-1:0] prdata_i,  // APB Read Data input
    input logic                  pslverr_i  // APB Slave Error input
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Type Definations
  //////////////////////////////////////////////////////////////////////////////////////////////////

  typedef enum int unsigned {
    GET_C,
    GET_W,
    APB_SEL,
    APB_EN,
    SEND_R,
    SEND_B
  } state_t;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Internal Signals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  state_t current_state;
  state_t next_state;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Combinationals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb begin

    next_state = current_state;
    c_ready_o  = 1'b0;

    case (current_state)

      GET_C: begin
        c_ready_o = 1'b1;
        if (c_wenable_i && c_valid_i) begin
          next_state = GET_W;
        end else if (~c_wenable_i && c_valid_i) begin
          next_state = APB_SEL;
        end
      end

      // TODO ASSIGNMENT

      default: begin
        next_state = GET_C;
      end

    endcase
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Sequentials
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      current_state <= GET_C;
    end else begin
      current_state <= next_state;
    end
  end


endmodule
