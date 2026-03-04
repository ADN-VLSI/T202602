interface apb_if #(
    parameter int ADDR_WIDTH = 8,
    parameter int DATA_WIDTH = 32
) (
    input logic arst_ni,  // active-low asynchronous reset
    input logic clk_i     // clock
);

  // Control Channel
  logic [  ADDR_WIDTH-1:0] c_addr_i;
  logic                    c_wenable_i;
  logic                    c_valid_i;
  logic                    c_ready_o;

  // Write Data Channel
  logic [  DATA_WIDTH-1:0] w_data_i;
  logic [DATA_WIDTH/8-1:0] w_strb_i;
  logic                    w_valid_i;
  logic                    w_ready_o;

  // Read Data Channel
  logic [  DATA_WIDTH-1:0] r_data_o;
  logic                    r_valid_o;
  logic                    r_ready_i;

  // Response Channel
  logic                    b_slverr_o;
  logic                    b_valid_o;
  logic                    b_ready_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////// CONTROL CHANNEL METHODS /////////////////
  // TODO: Alif: Add control channel methods if needed
  // CONTROL CHANNEL METHODS

  semaphore ctrl_sema = new(1);
  // Reset control channel
  task automatic ctrl_reset();
    c_addr_i    <= '0;
    c_wenable_i <= 1'b0;
    c_valid_i   <= 1'b0;
  endtask


  // Send control request (address phase)
  task automatic ctrl_request(
      input  logic [ADDR_WIDTH-1:0] addr,
      input  logic                  wenable
  );
    ctrl_sema.get(1);

    // Align to clock edge
    @(posedge clk_i);

    c_addr_i    <= addr;
    c_wenable_i <= wenable;
    c_valid_i   <= 1'b1;

    // Wait for ready (clock synchronous)
    while (!c_ready_o)
      @(posedge clk_i);

    // Deassert valid after handshake
    @(posedge clk_i);
    c_valid_i <= 1'b0;

    ctrl_sema.put(1);
  endtask


  // Wait until control handshake completes
  task automatic ctrl_wait_handshake();
    while (!(c_valid_i && c_ready_o))
      @(posedge clk_i);
  endtask








  ///////////////// WRITE DATA CHANNEL METHODS /////////////////
  // TODO: Ratul: Add write data channel methods if needed


  ///////////////// READ DATA CHANNEL METHODS /////////////////
  // TODO: Sabbir: Add read data channel methods if needed


  ///////////////// RESPONSE CHANNEL METHODS /////////////////
  // TODO: Sabbir: Add response channel methods if needed

endinterface
