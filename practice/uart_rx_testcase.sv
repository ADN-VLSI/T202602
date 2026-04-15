"RX": begin
  automatic string dut_rx_msg = "";
  automatic string intf_tx_msg = "Hello UART RX!";

  fork

    // 🔹 Interface Transmitter (Send data to DUT RX)
    begin : intf_transmitter_block
      automatic bit tx_parity;

      // UART initialization (same as TX test)
      apb_intf.write(CTRL_ADDR, 'b110);  // flush FIFO
      apb_intf.write(CTRL_ADDR, 'b000);  // disable flush
      apb_intf.write(CLK_DIV_ADDR, 'd100); // baud rate set
      apb_intf.write(CTRL_ADDR, 'b001);  // enable clock

      for (int i = 0; i < intf_tx_msg.len(); i++) begin
        uart_intf.send_tx(intf_tx_msg[i], tx_parity, 1000000, 0, 0, 0, 8);
      end

      $display("INTERFACE TX DONE");
    end


    // 🔹 DUT Receiver (Read from RX_DATA register)
    begin : dut_receiver_block
      automatic logic [31:0] rdata;

      for (int i = 0; i < intf_tx_msg.len(); i++) begin
        @(posedge irq_rx_valid);   // wait for valid data
        apb_intf.read(RX_DATA_ADDR, rdata);
        dut_rx_msg = {dut_rx_msg, rdata[7:0]};
      end

      $display("DUT RX DONE");
    end

  join   // IMPORTANT: wait for both blocks


  // 🔹 Final Verification
  if (dut_rx_msg != intf_tx_msg) begin
    $display("INTF TX: %s", intf_tx_msg);
    $display("DUT  RX: %s", dut_rx_msg);
    $fatal(1, "\033[1;31mTEST FAILED\033[0m");
  end

end