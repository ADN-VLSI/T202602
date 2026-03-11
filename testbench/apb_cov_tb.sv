module apb_cov_tb;

  initial $display("\033[7;38m APB COVERAGE TEST STARTED \033[0m");
  final $display("\033[7;38m  APB COVERAGE TEST ENDED  \033[0m");

  covergroup cg_apb with function sample(bit psel, bit penable, bit pwrite, logic [3:0] pstrb, bit pready);
    coverpoint psel {
      bins psel_inactive = {0};
      bins psel_active = {1};
    }
    coverpoint penable {
      bins enable_low = {0};
      bins enable_high = {1};
    }
    coverpoint pwrite {
      bins pwrite_read = {0};
      bins pwrite_write = {1};
    }
    coverpoint pstrb {
      bins pstrb_none = {4'b0000};
      bins pstrb_byte0 = {4'b0001};
      bins pstrb_byte1 = {4'b0010};
      bins pstrb_byte2 = {4'b0100};
      bins pstrb_byte3 = {4'b1000};
      bins pstrb_multi = {[4'b0011 : 4'b1111]};
    }
    coverpoint pready {
      bins pready_not_ready = {0};
      bins pready_ready = {1};
    }
    cross___psel___penable: cross psel, penable;
    cross___pwrite___pstrb: cross pwrite, pstrb;
    cross___psel___pwrite___pready: cross psel, pwrite, pready;
  endgroup

  cg_apb cg = new();

  initial begin
    bit psel, penable, pwrite, pready;
    logic [3:0] pstrb;
    int transaction_count = 0;

    while (cg.get_inst_coverage() < 90) begin
      void'(std::randomize(
          psel, penable, pwrite, pstrb, pready
      ) with {
        psel inside {0, 1};
        penable inside {0, 1};
        pwrite inside {0, 1};
        pstrb inside {4'b0000, 4'b0001, 4'b0010, 4'b0100, 4'b1000, 4'b0011, 4'b0101, 4'b1010, 4'b1111};
        pready inside {0, 1};
        if (penable == 1) psel == 1;
        if (pwrite == 0) pstrb == 4'b0000;
      });
      
      cg.sample(psel, penable, pwrite, pstrb, pready);
      transaction_count++;
      $display("[%0d] psel:%b, penable:%b, pwrite:%b, pstrb:%4b, pready:%b", 
               transaction_count, psel, penable, pwrite, pstrb, pready);
    end

    $finish;
  end

endmodule
