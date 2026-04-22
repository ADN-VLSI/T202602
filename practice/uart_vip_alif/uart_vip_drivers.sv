`include "uart_seq_item.sv"

`ifndef __GUARD_UART_DRIVER_SV__
`define __GUARD_UART_DRIVER_SV__ 0

class uart_driver;

  // ================= INTERFACE =================
  virtual uart_if vif;

  // ================= MAILBOX =================
  mailbox #(uart_seq_item) mbx;


  // ================= CONSTRUCTOR =================
  function new(virtual uart_if vif,
               mailbox #(uart_seq_item) mbx);
    this.vif = vif;
    this.mbx = mbx;
  endfunction


  // ================= RESET =================
  task reset();
    $display("[UART_DRV] Reset...");
    vif.reset();
  endtask


  // ================= WRITE / TX =================
  task send_byte(bit [7:0] data);
    vif.transmit(data);
    $display("[UART_DRV] TX DATA=%h", data);
  endtask


  // ================= READ / RX =================
  task recv_byte(output bit [7:0] data);
    vif.receive(data);
    $display("[UART_DRV] RX DATA=%h", data);
  endtask


  // ================= MAIN RUN =================
  task run();

    uart_seq_item item;
    bit [7:0] rx_data;

    forever begin

      // Get transaction
      mbx.get(item);

      item.display();

      // Configure UART
      vif.set_baud_rate(item.baud_div);

      if(item.parity_en)
        vif.set_parity(item.parity_en, item.parity_type);

      // TX or RX operation
      if(item.is_tx)
        send_byte(item.data);
      else
        recv_byte(rx_data);

      // Optional delay
      if(item.delay > 0)
        repeat(item.delay) @(posedge vif.clk);

    end

  endtask

endclass

`endif