module cdc_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4   // depth = 2^ADDR_WIDTH
)(
    input  logic                  wr_clk,
    input  logic                  rd_clk,
    input  logic                  wr_rst_n,
    input  logic                  rd_rst_n,

    // Write side
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic                  wr_en,
    output logic                  full,

    // Read side
    output logic [DATA_WIDTH-1:0] rd_data,
    input  logic                  rd_en,
    output logic                  empty
);

    localparam int DEPTH = 1 << ADDR_WIDTH;

    // Memory (should infer dual-port RAM)
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Binary pointers
    logic [ADDR_WIDTH:0] wr_ptr_bin, rd_ptr_bin;

    // Gray pointers
    logic [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;

    // Synchronized Gray pointers
    logic [ADDR_WIDTH:0] wr_ptr_gray_sync;
    logic [ADDR_WIDTH:0] rd_ptr_gray_sync;

    //////////////////////////////////////////////////////////////////////
    // WRITE DOMAIN
    //////////////////////////////////////////////////////////////////////
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wr_ptr_bin  <= '0;
            wr_ptr_gray <= '0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
                wr_ptr_bin  <= wr_ptr_bin + 1;
                wr_ptr_gray <= ( (wr_ptr_bin + 1) >> 1 ) ^ (wr_ptr_bin + 1);
            end
        end
    end

    //////////////////////////////////////////////////////////////////////
    // READ DOMAIN
    //////////////////////////////////////////////////////////////////////
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rd_ptr_bin  <= '0;
            rd_ptr_gray <= '0;
            rd_data     <= '0;
        end else begin
            if (rd_en && !empty) begin
                rd_data    <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
                rd_ptr_bin <= rd_ptr_bin + 1;
                rd_ptr_gray <= ( (rd_ptr_bin + 1) >> 1 ) ^ (rd_ptr_bin + 1);
            end
        end
    end

    //////////////////////////////////////////////////////////////////////
    // SYNCHRONIZERS (2-FF)
    //////////////////////////////////////////////////////////////////////

    logic [ADDR_WIDTH:0] wr_gray_sync_ff1, wr_gray_sync_ff2;
    logic [ADDR_WIDTH:0] rd_gray_sync_ff1, rd_gray_sync_ff2;

    // Write pointer into READ domain
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_gray_sync_ff1 <= '0;
            wr_gray_sync_ff2 <= '0;
        end else begin
            wr_gray_sync_ff1 <= wr_ptr_gray;
            wr_gray_sync_ff2 <= wr_gray_sync_ff1;
        end
    end

    assign wr_ptr_gray_sync = wr_gray_sync_ff2;

    // Read pointer into WRITE domain
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rd_gray_sync_ff1 <= '0;
            rd_gray_sync_ff2 <= '0;
        end else begin
            rd_gray_sync_ff1 <= rd_ptr_gray;
            rd_gray_sync_ff2 <= rd_gray_sync_ff1;
        end
    end

    assign rd_ptr_gray_sync = rd_gray_sync_ff2;

    //////////////////////////////////////////////////////////////////////
    // FULL & EMPTY (GRAY DOMAIN)
    //////////////////////////////////////////////////////////////////////

    // FULL: MSB inverted trick (Gray comparison)
    assign full = (wr_ptr_gray ==
                  {~rd_ptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1],
                    rd_ptr_gray_sync[ADDR_WIDTH-2:0]});

    // EMPTY: pointers equal
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync);

endmodule