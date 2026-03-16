interface ci_if #(
    parameter int ADDR_WIDTH = 8,
    parameter int DATA_WIDTH = 32
) (
    input logic arst_ni,  // active-low asynchronous reset
    input logic clk_i     // clock
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Control Channel
  logic [  ADDR_WIDTH-1:0] c_addr;
  logic                    c_wenable;
  logic                    c_valid;
  logic                    c_ready;

  // Write Data Channel
  logic [  DATA_WIDTH-1:0] w_data;
  logic [DATA_WIDTH/8-1:0] w_strb;
  logic                    w_valid;
  logic                    w_ready;

  // Read Data Channel
  logic [  DATA_WIDTH-1:0] r_data;
  logic                    r_valid;
  logic                    r_ready;

  // Response Channel
  logic                    b_slverr;
  logic                    b_valid;
  logic                    b_ready;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  bit                      is_edge_aligned = '0;

  always @(posedge clk_i) begin
    is_edge_aligned <= '1;
    #1ps;
    is_edge_aligned <= '0;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Reset control channel
  task automatic master_reset();
    c_addr    <= '0;
    c_wenable <= '0;
    c_valid   <= '0;
    w_data    <= '0;
    w_strb    <= '0;
    w_valid   <= '0;
    r_ready   <= '0;
    b_ready   <= '0;
  endtask

  // Reset control channel
  task automatic slave_reset();
    c_ready   <= '0;
    w_ready   <= '0;
    r_data    <= '0;
    r_valid   <= '0;
    b_slverr  <= '0;
    b_valid   <= '0;
  endtask

  ////////////////////////////////////////////////
  // CONTROL CHANNEL METHODS
  ////////////////////////////////////////////////

  // Master: Send control request (address phase)
  semaphore ctrl_send_sema = new(1);
  task automatic send_c(input logic [ADDR_WIDTH-1:0] addr, input logic wenable);
    ctrl_send_sema.get(1);
    if (arst_ni) wait (is_edge_aligned);
    c_addr    <= addr;
    c_wenable <= wenable;
    c_valid   <= 1'b1;
    do @(posedge clk_i); while (!c_ready && arst_ni);
    c_valid <= 1'b0;
    ctrl_send_sema.put(1);
  endtask

  // Slave: Receive control request (address phase)
  semaphore ctrl_recv_sema = new(1);
  task automatic recv_c(output logic [ADDR_WIDTH-1:0] addr, output logic wenable);
    ctrl_recv_sema.get(1);
    if (arst_ni) wait (is_edge_aligned);
    c_ready <= 1'b1;
    do @(posedge clk_i); while (!c_valid && arst_ni);
    addr = c_addr;
    wenable = c_wenable;
    c_ready <= 1'b0;
    ctrl_recv_sema.put(1);
  endtask

  // Monitor: Look at control request
  task automatic look_c(output logic [ADDR_WIDTH-1:0] addr, output logic wenable);
    do @(posedge clk_i); while (!(c_valid && c_ready && arst_ni));
    addr = c_addr;
    wenable = c_wenable;
  endtask

  ////////////////////////////////////////////////
  // WRITE DATA CHANNEL METHODS
  ////////////////////////////////////////////////

  // Master: Send write data (data phase)
  semaphore w_send_sema = new(1);
  task automatic send_w(input logic [DATA_WIDTH-1:0] data, input logic [DATA_WIDTH/8-1:0] strb);
    w_send_sema.get(1);
    if (arst_ni) wait (is_edge_aligned);
    w_data  <= data;
    w_strb  <= strb;
    w_valid <= 1'b1;
    do @(posedge clk_i); while (!w_ready && arst_ni);
    w_valid <= 1'b0;
    w_send_sema.put(1);
  endtask

  // Slave: Receive write data (data phase)
  semaphore w_recv_sema = new(1);
  task automatic recv_w(output logic [DATA_WIDTH-1:0] data, output logic [DATA_WIDTH/8-1:0] strb);
    w_recv_sema.get(1);
    if (arst_ni) wait (is_edge_aligned);
    w_ready <= 1'b1;
    do @(posedge clk_i); while (!w_valid && arst_ni);
    data = w_data;
    strb = w_strb;
    w_ready <= 1'b0;
    w_recv_sema.put(1);
  endtask

  // Monitor: Look at write data
  task automatic look_w(output logic [DATA_WIDTH-1:0] data, output logic [DATA_WIDTH/8-1:0] strb);
    do @(posedge clk_i); while (!(w_valid && w_ready && arst_ni));
    data = w_data;
    strb = w_strb;
  endtask

  ////////////////////////////////////////////////
  // READ DATA CHANNEL METHODS
  ////////////////////////////////////////////////

  // Slave: Send read data (data phase)
  semaphore r_send_sema = new(1);
  task automatic send_r(input logic [DATA_WIDTH-1:0] data);
    r_send_sema.get(1);
    if (arst_ni) wait (is_edge_aligned);
    r_data  <= data;
    r_valid <= 1'b1;
    do @(posedge clk_i); while (!r_ready && arst_ni);
    r_valid <= 1'b0;
    r_send_sema.put(1);
  endtask

  // Master: Receive read data
  semaphore r_recv_sema = new(1);
  task automatic recv_r(output logic [DATA_WIDTH-1:0] data);
    r_recv_sema.get(1);
    if (arst_ni) wait (is_edge_aligned);
    r_ready <= 1'b1;
    do @(posedge clk_i); while (!r_valid && arst_ni);
    data = r_data;
    r_ready <= 1'b0;
    r_recv_sema.put(1);
  endtask

  // Monitor: Look at read data
  task automatic look_r(output logic [DATA_WIDTH-1:0] data);
    do @(posedge clk_i); while (!(r_valid && r_ready && arst_ni));
    data = r_data;
  endtask

  ////////////////////////////////////////////////
  // RESPONSE CHANNEL METHODS
  ////////////////////////////////////////////////

  // Slave: Send response
  semaphore b_send_sema = new(1);
  task automatic send_b(input logic slverr);
    b_send_sema.get(1);
    if (arst_ni) wait (is_edge_aligned);
    b_slverr <= slverr;
    b_valid  <= 1'b1;
    do @(posedge clk_i); while (!b_ready && arst_ni);
    b_valid <= 1'b0;
    b_send_sema.put(1);
  endtask

  // Master: Get response
  semaphore b_recv_sema = new(1);
  task automatic recv_b(output logic slverr);
    b_recv_sema.get(1);
    if (arst_ni) wait (is_edge_aligned);
    b_ready <= 1'b1;
    do @(posedge clk_i); while (!b_valid && arst_ni);
    slverr = b_slverr;
    b_ready <= 1'b0;
    b_recv_sema.put(1);
  endtask

  // Monitor: Look at response
  task automatic look_b(output logic slverr);
    do @(posedge clk_i); while (!(b_valid && b_ready && arst_ni));
    slverr = b_slverr;
  endtask

endinterface
