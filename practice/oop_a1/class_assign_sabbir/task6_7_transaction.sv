//Task 6 & 7
class transaction;
  rand bit [7:0] addr;
  rand bit [7:0] data;

  // Constraint 
  constraint addr_constraint {
    addr >= 8'd10;
    addr <= 8'd20;
  }

  // Display function
  function void display();
    $display("Transaction: addr=0x%h (dec: %d), data=0x%h", addr, addr, data);
  endfunction
endclass

// Testbench for class 6 & 7
module task6_7_transaction_tb;
  initial begin
    $display("Transaction Randomization with Constraint \n");

    transaction txn;

    // Randomize and printed 5 transactions
    for(int i = 0; i < 5; i++) begin
      txn = new();
      if(txn.randomize()) begin
        $display("Transaction %0d:", i+1);
        txn.display();
        $display("");
      end else begin
        $display("Randomization failed for transaction %0d", i+1);
      end
    end

    $display("\n");
  end
endmodule