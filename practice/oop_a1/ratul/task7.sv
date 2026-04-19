class transaction;
  rand bit [7:0] addr;
  rand bit [7:0] data;

  constraint addr_range { addr inside {[10:20]}; }
endclass

module test_transaction_constraint;
  transaction t;

  initial begin
    t = new();
    for(int i=0; i<5; i++) begin
      t.randomize();
      $display("Transaction %0d: addr=%0d, data=%0d", i+1, t.addr, t.data);
    end
  end
endmodule