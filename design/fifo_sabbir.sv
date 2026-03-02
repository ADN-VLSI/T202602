// Author: Sabbir 
// Description: FIFO Buffer using Memory Module

module fifo_sabbir #(
    parameter int FIFO_SIZE  = 4,   // FIFO depth = 2^FIFO_SIZE
    parameter int DATA_WIDTH = 8    // Data width
)(
    input  logic clk_i,
    input  logic arst_ni,                    // asynchronous reset
    input  logic [DATA_WIDTH-1:0] data_in_i,
    input  logic data_in_valid_i,
    output logic data_in_ready_o,
    output logic [DATA_WIDTH-1:0] data_out_o,
    output logic data_out_valid_o,
    input  logic data_out_ready_i,
    output logic [FIFO_SIZE:0] count_o
);

  // Internal pointers
  logic [FIFO_SIZE:0] wr_ptr;
  logic [FIFO_SIZE:0] rd_ptr;
  logic [DATA_WIDTH-1:0] mem_data_out;

  // Full and empty flags
  logic full, empty;

  // Memory control signals
  logic mem_we, mem_re;

  // -----------------------------------
  // Instantiate memory (mem.sv)
  // -----------------------------------
  mem #(
      .ADDR_WIDTH(FIFO_SIZE),
      .DATA_WIDTH(DATA_WIDTH)
  ) fifo_mem (
      .clk_i  (clk_i),
      .waddr_i(wr_ptr[FIFO_SIZE-1:0]),
      .wdata_i(data_in_i),
      .we_i   (mem_we),
      .raddr_i(rd_ptr[FIFO_SIZE-1:0]),
      .rdata_o(mem_data_out)
  );

  // -----------------------------------
  // FIFO logic
  // -----------------------------------

  // Write pointer
  always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) wr_ptr <= '0;
      else if (mem_we) wr_ptr <= wr_ptr + 1;
  end

  // Read pointer
  always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) rd_ptr <= '0;
      else if (mem_re) rd_ptr <= rd_ptr + 1;
  end

  // Count = difference of pointers
  always_comb count_o = wr_ptr - rd_ptr;

  // Full / Empty detection
  always_comb begin
      empty = (wr_ptr == rd_ptr);
      full  = ((wr_ptr[FIFO_SIZE] != rd_ptr[FIFO_SIZE]) &&
               (wr_ptr[FIFO_SIZE-1:0] == rd_ptr[FIFO_SIZE-1:0]));
  end

  // Memory control
  always_comb begin
      mem_we = data_in_valid_i && !full;
      mem_re = data_out_ready_i && !empty;
  end

  // Output logic
  always_comb begin
      data_out_o       = mem_data_out;
      data_out_valid_o = !empty;
      data_in_ready_o  = !full;
  end

endmodule