
/////////////////////////////////////////////////////
// UART RX TEST CASES
/////////////////////////////////////////////////////


// --------------------------------------------------
// TEST 1 : Basic receive (0xA5)
// --------------------------------------------------
task test_1_basic();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST1] Basic RX test with data = 0xA5");

  uart_if.send_tx(8'hA5);
  uart_if.recv_rx(data, parity);

  if (data === 8'hA5)
    $display("TEST1 PASS: Data matched (0xA5)");
  else
    $display("TEST1 FAIL: Data mismatch");
endtask


// --------------------------------------------------
// TEST 2 : Zero data (0x00)
// --------------------------------------------------
task test_2_zero();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST2] RX test with data = 0x00");

  uart_if.send_tx(8'h00);
  uart_if.recv_rx(data, parity);

  if (data === 8'h00)
    $display("TEST2 PASS: Data matched (0x00)");
  else
    $display("TEST2 FAIL: Data mismatch");
endtask


// --------------------------------------------------
// TEST 3 : All ones (0xFF)
// --------------------------------------------------
task test_3_ff();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST3] RX test with data = 0xFF");

  uart_if.send_tx(8'hFF);
  uart_if.recv_rx(data, parity);

  if (data === 8'hFF)
    $display("TEST3 PASS: Data matched (0xFF)");
  else
    $display("TEST3 FAIL: Data mismatch");
endtask


// --------------------------------------------------
// TEST 4 : Even parity check
// --------------------------------------------------
task test_4_even_parity();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST4] Even parity verification");

  uart_if.send_tx(8'h55, .parity_enable(1), .parity_type(0));
  uart_if.recv_rx(data, parity);

  $display("TEST4 INFO: DATA=%0h PARITY=%0b", data, parity);
endtask


// --------------------------------------------------
// TEST 5 : Odd parity check
// --------------------------------------------------
task test_5_odd_parity();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST5] Odd parity verification");

  uart_if.send_tx(8'h55, .parity_enable(1), .parity_type(1));
  uart_if.recv_rx(data, parity);

  $display("TEST5 INFO: DATA=%0h PARITY=%0b", data, parity);
endtask


// --------------------------------------------------
// TEST 6 : Parity error injection
// --------------------------------------------------
task test_6_parity_error();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST6] Parity error injection test");

  uart_if.send_tx(8'h55, .parity_enable(1), .parity_type(0), .flip_parity(1));
  uart_if.recv_rx(data, parity);

  $display("TEST6 COMPLETED: Parity error scenario executed");
endtask


// --------------------------------------------------
// TEST 7 : Framing error (bad stop bit)
// --------------------------------------------------
task test_7_bad_stop();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST7] Framing error test (bad stop bit)");

  uart_if.send_tx(8'h5A, .bad_stop(1));
  uart_if.recv_rx(data, parity);

  $display("TEST7 COMPLETED: Framing error scenario executed");
endtask


// --------------------------------------------------
// TEST 8 : Back-to-back frames
// --------------------------------------------------
task test_8_back_to_back();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST8] Back-to-back frame reception");

  uart_if.send_tx(8'h12);
  uart_if.recv_rx(data, parity);

  uart_if.send_tx(8'h34);
  uart_if.recv_rx(data, parity);

  $display("TEST8 DONE: Back-to-back transfer completed");
endtask
  
