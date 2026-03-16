module protocol_cvtr_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // LOCAL PARAMETERS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int ADDR_WIDTH = 8;
  localparam int DATA_WIDTH = 32;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERNAL SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Global Signals
  logic                    arst_ni;
  logic                    clk_i;

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

  apb_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .ACT_AS_MEM(1)
  ) apb_intf (
      .arst_ni(arst_ni),
      .clk_i  (clk_i)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERNAL SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  protocol_cvtr #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  ) u_protocol_cvtr (
      .arst_ni    (arst_ni),
      .clk_i      (clk_i),
      .c_addr_i   (c_addr_i),
      .c_wenable_i(c_wenable_i),
      .c_valid_i  (c_valid_i),
      .c_ready_o  (c_ready_o),
      .w_data_i   (w_data_i),
      .w_strb_i   (w_strb_i),
      .w_valid_i  (w_valid_i),
      .w_ready_o  (w_ready_o),
      .r_data_o   (r_data_o),
      .r_valid_o  (r_valid_o),
      .r_ready_i  (r_ready_i),
      .b_slverr_o (b_slverr_o),
      .b_valid_o  (b_valid_o),
      .b_ready_i  (b_ready_i),
      .psel_o     (apb_intf.psel),
      .penable_o  (apb_intf.penable),
      .paddr_o    (apb_intf.paddr),
      .pwrite_o   (apb_intf.pwrite),
      .pwdata_o   (apb_intf.pwdata),
      .pstrb_o    (apb_intf.pstrb),
      .pready_i   (apb_intf.pready),
      .prdata_i   (apb_intf.prdata),
      .pslverr_i  (apb_intf.pslverr)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task automatic apply_reset();
    arst_ni <= '0;
    clk_i   <= '0;
    apb_intf.reset();
    #100ns;
    arst_ni <= '1;
  endtask

  task automatic start_clock();
    fork
      forever #5ns clk_i = ~clk_i;
    join_none
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    $timeformat(-9, 0, "ns");
    $dumpfile("protocol_cvtr_tb.vcd");
    $dumpvars(0, protocol_cvtr_tb);

    apply_reset();
    start_clock();

    // // Just checking if interface can act as mem
    // begin
    //   int data;
    //   apb_intf.write(0, 'h12345678);
    //   apb_intf.write(4, 'h90ABCDEF);
    //   apb_intf.read(0, data);
    //   $display("Read data: %h", data);
    //   apb_intf.read(4, data);
    //   $display("Read data: %h", data);
    // end

    #100ns;
    $finish;

  end

endmodule
