interface ci_if #(
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

  
  ///////////////// WRITE DATA CHANNEL METHODS /////////////////
  // TODO: Ratul: Add write data channel methods if needed

  task automatic send_w(input logic [DATA_WIDTH-1:0] data,
                            input logic [DATA_WIDTH/8-1:0] strb);
    w_data_i <= data;
    w_strb_i <= strb;
    w_valid_i <= 1'b1;
    do @(posedge clk_i); while (!w_ready_o);
    w_valid_i <= 1'b0;
  endtask

  task automatic recv_w(output logic [DATA_WIDTH-1:0] data,
                          output logic [DATA_WIDTH/8-1:0] strb);
    w_ready_o <= 1'b1;
    do @(posedge clk_i); while (!w_valid_i);
    data = w_data_i;
    strb = w_strb_i;
    w_ready_o <= 1'b0;
  endtask

  task automatic look_w(output logic [DATA_WIDTH-1:0] data,
                          output logic [DATA_WIDTH/8-1:0] strb);
    do @(posedge clk_i); while (!(w_valid_i && w_ready_o));
    data = w_data_i;
    strb = w_strb_i;
  endtask

  task automatic reset_w();
    w_data_i  <= '0;
    w_strb_i  <= '0;
    w_valid_i <= 1'b0;
  endtask

  ///////////////// READ DATA CHANNEL METHODS /////////////////
  // TODO: Sabbir: Add read data channel methods if needed
    // Slave: Send read data
  task automatic send_read_data(
      input logic [DATA_WIDTH-1:0] data
  );
    @(posedge clk_i);
    r_data_o  <= data;
    r_valid_o <= 1'b1;

do @(posedge clk_i);
while (!r_ready_i)
    
    r_valid_o <= 1'b0;
  endtask


  // Master: Receive read data
  task automatic get_read_data(
      output logic [DATA_WIDTH-1:0] data
  );
    r_ready_i <= 1'b1;
    wait (r_valid_o);
    data = r_data_o;
    @(posedge clk_i);
    r_ready_i <= 1'b0;
  endtask



  ///////////////// RESPONSE CHANNEL METHODS /////////////////
  // TODO: Sabbir: Add response channel methods if needed
    // Slave: Send response
  task automatic send_response(
      input logic slverr
  );
    @(posedge clk_i);
    b_slverr_o <= slverr;
    b_valid_o  <= 1'b1;

    wait (b_ready_i);
    @(posedge clk_i);
    b_valid_o <= 1'b0;
  endtask


  // Master: Get response
  task automatic get_response(
      output logic slverr
  );
    b_ready_i <= 1'b1;
    wait (b_valid_o);
    slverr = b_slverr_o;
    @(posedge clk_i);
    b_ready_i <= 1'b0;
  endtask

endinterface
