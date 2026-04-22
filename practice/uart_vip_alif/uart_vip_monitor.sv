`include "uart_rsp_item.sv"

`ifndef __GUARD_UART_MONITOR_SV__
`define __GUARD_UART_MONITOR_SV__ 0

class uart_monitor;

  // ================= INTERFACE =================
  virtual uart_if vif;

  // ================= MAILBOX =================
  mailbox #(uart_rsp_item) mbx;


  // ================= CONSTRUCTOR =================
  function new(virtual uart_if vif,
               mailbox #(uart_rsp_item) mbx);
    this.vif = vif;
    this.mbx = mbx;
  endfunction


  // ================= CAPTURE TASK =================
  task capture(output uart_rsp_item item);

    bit [7:0] rx_data;
    bit       data_valid;
    bit       parity_error;
    bit       framing_error;

    // Get transaction from interface
    vif.monitor_transaction(rx_data,
                             data_valid,
                             parity_error,
                             framing_error);

    // Create response item
    item = new();
    item.data          = rx_data;
    item.data_valid    = data_valid;
    item.parity_error  = parity_error;
    item.framing_error = framing_error;

    // Debug print
    $display("[UART_MON] DATA=%h VALID=%b PAR_ERR=%b FRM_ERR=%b",
              rx_data, data_valid, parity_error, framing_error);

  endtask


  // ================= MAIN RUN =================
  task run();

    uart_rsp_item item;

    forever begin

      capture(item);

      mbx.put(item);

      #2; // small delay for stability

    end

  endtask


  // ================= IDLE CHECK =================
  task wait_till_idle(input int timeout = 1000);

    $display("[UART_MON] Waiting for idle...");

    vif.wait_till_idle(timeout);

    $display("[UART_MON] Bus is idle");

  endtask

endclass

`endif