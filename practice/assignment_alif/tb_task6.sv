module tb;

  transaction t;

  initial begin
    // object creation
    t = new();

    // generate and print 5 random transactions
    for (int i = 0; i < 5; i++) begin
      if (t.randomize()) begin
        $display("Transaction %0d", i+1);
        t.display();
      end
      else begin
        $display("Randomization failed at %0d", i+1);
      end
    end
  end

endmodule