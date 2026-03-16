module custom_mem_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // LOCAL PARAMETERS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int ADDR_WIDTH = 8;
  localparam int DATA_WIDTH = 32;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERNAL SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Global Signals
  logic arst_ni;
  logic clk_i;

  ci_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  ) ci (
      .arst_ni(arst_ni),
      .clk_i  (clk_i)
  );

  apb_if #(
      .ADDR_WIDTH  (ADDR_WIDTH),
      .DATA_WIDTH  (DATA_WIDTH),
      .ACT_AS_MEM  (1),
      .JIBRISH_DATA(0)
  ) apb (
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
      .c_addr_i   (ci.c_addr),
      .c_wenable_i(ci.c_wenable),
      .c_valid_i  (ci.c_valid),
      .c_ready_o  (ci.c_ready),
      .w_data_i   (ci.w_data),
      .w_strb_i   (ci.w_strb),
      .w_valid_i  (ci.w_valid),
      .w_ready_o  (ci.w_ready),
      .r_data_o   (ci.r_data),
      .r_valid_o  (ci.r_valid),
      .r_ready_i  (ci.r_ready),
      .b_slverr_o (ci.b_slverr),
      .b_valid_o  (ci.b_valid),
      .b_ready_i  (ci.b_ready),
      .psel_o     (apb.psel),
      .penable_o  (apb.penable),
      .paddr_o    (apb.paddr),
      .pwrite_o   (apb.pwrite),
      .pwdata_o   (apb.pwdata),
      .pstrb_o    (apb.pstrb),
      .pready_i   (apb.pready),
      .prdata_i   (apb.prdata),
      .pslverr_i  (apb.pslverr)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task automatic apply_reset();
    arst_ni <= '0;
    clk_i   <= '0;
    ci.master_reset();
    apb.reset();
    #100ns;
    arst_ni <= '1;
  endtask

  task automatic start_clock();
    fork
      forever #5ns clk_i <= ~clk_i;
    join_none
    @(posedge clk_i);
  endtask

  task automatic write(input logic [ADDR_WIDTH-1:0] addr, input logic [DATA_WIDTH-1:0] data,
                       input logic [DATA_WIDTH/8-1:0] strb);
    bit slverr;
    fork
      ci.send_c(addr, 'b1);
      ci.send_w(data, strb);
      ci.recv_b(slverr);
    join
  endtask

  task automatic read(input logic [ADDR_WIDTH-1:0] addr, output logic [DATA_WIDTH-1:0] data);
    bit slverr;
    fork
      ci.send_c(addr, 'b0);
      ci.recv_r(data);
      ci.recv_b(slverr);
    join
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [7:0] ref_mem[int];

  int pass_cnt;
  int fail_cnt;

  initial begin
    #1ms;
    $fatal(1, "\033[1;31m TIMEOUT \033[0m");
  end

  initial begin

    logic [DATA_WIDTH-1:0] rdata;
    logic                  slverr;

    $timeformat(-9, 0, "ns");
    $dumpfile("custom_mem_tb.vcd");
    $dumpvars(0, custom_mem_tb);

    apply_reset();
    start_clock();


    repeat (64) begin
      randcase

        1: begin  // WRITE
          logic [  ADDR_WIDTH-1:0]      addr;
          logic [DATA_WIDTH/8-1:0][7:0] data;
          logic [DATA_WIDTH/8-1:0]      strb;
          addr = $urandom * 4;
          data = $urandom;
          strb = $urandom;
          write(addr, data, strb);
          // Update reference memory with written data
          for (int i = 0; i < DATA_WIDTH / 8; i++) begin
            if (strb[i]) begin
              ref_mem[addr+i] = data[i];
              // $display("\033[0;33mWrote 0x%02x to address 0x%02x\033[0m", data[i], addr + i);
            end
          end
        end

        1: begin  // READ
          logic [  ADDR_WIDTH-1:0]      addr;
          logic [DATA_WIDTH/8-1:0][7:0] data;
          addr = $urandom * 4;
          read(addr, data);
          // Compare read data with reference memory
          for (int i = 0; i < DATA_WIDTH / 8; i++) begin
            if (data[i] !== ref_mem[addr+i]) begin
              $display("\033[0;31mError at address 0x%02x: expected 0x%02x, got 0x%02x\033[0m",
                       addr + i, ref_mem[addr+i], data[i]);
              fail_cnt++;
            end else begin
              // $display("\033[0;32mMatch at address 0x%02x: expected 0x%02x, got 0x%02x\033[0m",
              //          addr + i, ref_mem[addr+i], data[i]);
              pass_cnt++;
            end
          end
        end

      endcase
    end

    // // Sanity Test
    // write(0, 'hBEEFBEEF, 'b1111);
    // write(4, 'hF00DF00D, 'b1111);
    // write(4, 'hCAFECAFE, 'b0011);
    // write(8, 'hFACEFACE, 'b1111);

    // for (int i = 0; i < 3; i++) begin
    //   read(i*4, rdata);
    //   $display("Read data at address 0x%02x: 0x%08x", i*4, rdata);
    // end

    // // Just checking if interface can act as mem
    // begin
    //   int data;
    //   apb.write(0, 'h12345678);
    //   apb.write(4, 'h90ABCDEF);
    //   apb.read(0, data);
    //   $display("Read data: %h", data);
    //   apb.read(4, data);
    //   $display("Read data: %h", data);
    // end

    #100ns;

    $display("\n\033[1;32m TEST SUMMARY: %0d PASSED, %0d FAILED \033[0m\n", pass_cnt, fail_cnt);

    $finish;

  end

endmodule
