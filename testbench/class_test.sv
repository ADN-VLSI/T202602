module class_test;

  initial $display("\033[7;38m TEST STARTED \033[0m");
  final $display("\033[7;38m  TEST ENDED  \033[0m");

  covergroup cg_divs with function sample(int refdiv, int fbdiv);
    coverpoint refdiv {
      bins refdiv_bins[] = {[1 : 7]};
    }
    coverpoint fbdiv {
      bins fbdiv_bins_low = {[8 : 15]};
      bins fbdiv_bins_mid = {[16 : 50]};
      bins fbdiv_bins_high = {[51 : 100]};
    }
    cross___refdiv___fbdiv: cross refdiv, fbdiv;
  endgroup

  cg_divs cg = new();

  initial begin
    int fin, fout, refdiv, fbdiv;
    fin = 100;

    while (cg.get_inst_coverage() < 90) begin
      void'(std::randomize(
          refdiv, fbdiv
      ) with {
        refdiv inside {[1 : 7]};
        fbdiv inside {[8 : 100]};
        fin * fbdiv >= refdiv * 8;
        fin * fbdiv <= refdiv * 5000;
      });
      fout = fin * fbdiv / refdiv;
      cg.sample(refdiv, fbdiv);
      $display("fin:%03d, fout:%04d, refdiv:%0d, fbdiv:%03d", fin, fout, refdiv, fbdiv);
    end

    $finish;
  end

endmodule
