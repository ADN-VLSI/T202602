module tb;

  transaction t;

  initial begin
    t = new();

    for (int i = 0; i < 5; i++) begin
      if (t.randomize()) begin
        $display("Transaction %0d", i+1);
        t.display();
      end
    end

  end

endmodule