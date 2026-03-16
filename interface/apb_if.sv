interface apb_if #(
    parameter int ADDR_WIDTH   = 8,
    parameter int DATA_WIDTH   = 32,
    parameter bit ACT_AS_MEM   = 0,
    parameter int JIBRISH_DATA = 0
) (
    input logic arst_ni,  // active-low asynchronous reset
    input logic clk_i     // clock
);

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNAL DECLARATIONS
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  logic                         psel;
  logic                         penable;
  logic [  ADDR_WIDTH-1:0]      paddr;
  logic                         pwrite;
  logic [DATA_WIDTH/8-1:0][7:0] pwdata;
  logic [DATA_WIDTH/8-1:0]      pstrb;

  logic                         pready;
  logic [DATA_WIDTH/8-1:0][7:0] prdata;
  logic                         pslverr;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERNAL VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  bit                           is_edge_aligned = 0;

  always @(posedge clk_i) begin
    is_edge_aligned = 1;
    #1;
    is_edge_aligned = 0;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////


  semaphore apb_sema = new(1);
  task automatic do_transaction(input logic write, input logic [ADDR_WIDTH-1:0] address,
                                input logic [DATA_WIDTH-1:0] write_data,
                                input logic [DATA_WIDTH/8-1:0] write_strobe,
                                output logic [DATA_WIDTH-1:0] read_data);

    apb_sema.get(1);

    // TODO Solve misalignment issue for non-edge aligned accesses
    if (!clk_i) @(posedge clk_i);

    // Setup phase
    psel    <= '1;
    penable <= '0;
    paddr   <= address;
    pwrite  <= write;
    pwdata  <= write_data;
    pstrb   <= write_strobe;

    // Wait one clock cycle
    @(posedge clk_i);

    // Enable phase
    penable <= '1;

    do @(posedge clk_i); while (!pready);

    // Capture read data
    read_data = prdata;

    apb_sema.put(1);

    // Deassert signals
    psel    <= '0;
    penable <= '0;
  endtask

  task automatic reset();
    psel    <= '0;
    penable <= '0;
    paddr   <= '0;
    pwrite  <= '0;
    pwdata  <= '0;
    pstrb   <= '0;
  endtask

  task automatic write_32(input logic [ADDR_WIDTH-1:0] address,
                          input logic [DATA_WIDTH-1:0] write_data);
    logic [DATA_WIDTH-1:0] read_data_dummy;
    do_transaction('1, address, write_data, 'h0f, read_data_dummy);
  endtask

  task automatic read_32(input logic [ADDR_WIDTH-1:0] address,
                         output logic [DATA_WIDTH-1:0] read_data);
    do_transaction('0, address, '0, '0, read_data);
  endtask

  task automatic write(input logic [ADDR_WIDTH-1:0] address,
                       input logic [DATA_WIDTH-1:0] write_data);
    write_32(address, write_data);
  endtask

  task automatic read(input logic [ADDR_WIDTH-1:0] address,
                      output logic [DATA_WIDTH-1:0] read_data);
    read_32(address, read_data);
  endtask

  task automatic get_transaction(output logic write, output logic [ADDR_WIDTH-1:0] address,
                                 output logic [DATA_WIDTH-1:0] write_data,
                                 output logic [DATA_WIDTH/8-1:0] write_strobe,
                                 output logic [DATA_WIDTH-1:0] read_data, output logic slverr);

    //Wait for setup phase
    do @(posedge clk_i); while (!(psel == '1 && penable == '0));

    //Wait for access phase
    do @(posedge clk_i); while (!(psel == '1 && penable == '1));

    //Update information as long as enable stage high
    while (psel == '1 && penable == '1) begin
      write        = pwrite;
      address      = paddr;
      write_data   = pwdata;
      write_strobe = pstrb;
      read_data    = prdata;
      slverr       = pslverr;
      @(negedge clk_i);
    end

  endtask

  task automatic wait_till_idle(input int tx_len = 3);
    int i;
    i = 0;
    while (i < tx_len * 2) begin
      @(posedge clk_i);
      i++;
      if (psel == 1) i = 0;
    end
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ACT AS MEMORY (OPTIONAL)
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (ACT_AS_MEM) begin

    logic [7:0] mem[int];

    localparam int IDLE = 0;
    localparam int SETUP = 1;
    localparam int ACCESS = 2;

    int                           current_state;
    int                           next_state;

    logic                         internal_pready;
    logic [DATA_WIDTH/8-1:0][7:0] internal_prdata;
    logic                         internal_pslverr;

    assign pready  = (penable) ? internal_pready : '0;
    assign prdata  = (penable) ? internal_prdata : '0;
    assign pslverr = (penable) ? internal_pslverr : '0;

    always_comb begin
      next_state = current_state;

      case (current_state)

        IDLE: begin
          if (psel == 1 && penable == 0) begin
            next_state = SETUP;
          end
        end

        SETUP: begin
          if (psel == 1 && penable == 1) begin
            next_state = ACCESS;
          end
        end

        ACCESS: begin
          if (psel == 0) begin
            next_state = IDLE;
          end else if (penable == 0) begin
            next_state = SETUP;
          end
        end

        default: next_state = IDLE;

      endcase
    end

    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (!arst_ni) begin
        current_state <= IDLE;
      end else begin
        current_state <= next_state;
      end
    end

    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (!arst_ni) begin
        internal_pready  <= '0;
        internal_pslverr <= '0;
      end else begin
        if (next_state == SETUP) begin
          internal_pready <= 1'b1;
        end else if (next_state == IDLE) begin
          internal_pready <= 1'b0;
        end
      end
    end

    always @(posedge clk_i) begin
      if (next_state == SETUP) begin
        foreach (pstrb[i]) begin
          if (JIBRISH_DATA) begin
            internal_prdata[i] <= $urandom;
          end else begin
            internal_prdata[i] <= mem[paddr+i];
            if (pstrb[i] & pwrite) mem[paddr+i] = pwdata[i];
          end
        end
      end
    end

  end

endinterface
