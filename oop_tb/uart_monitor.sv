`include "uart_rsp_item.sv"

`ifndef __GUARD_UART_MONITOR_SV__
`define __GUARD_UART_MONITOR_SV__ 0

class uart_monitor;

  virtual uart_if intf;

  mailbox #(uart_rsp_item) mbx;

  function new(virtual uart_if intf, mailbox #(uart_rsp_item) mbx);
    this.intf = intf;
    this.mbx = mbx;
  endfunction

  task automatic run();

    fork

      forever begin
        uart_rsp_item item;
        item                 = new();
        intf.recv_rx(item.data, item.parity);
        item.baud_rate       = intf.BAUD_RATE;
        item.parity_enable   = intf.PARITY_ENABLE;
        item.parity_type     = intf.PARITY_TYPE;
        item.second_stop_bit = intf.SECOND_STOP_BIT;
        item.data_bits       = intf.DATA_BITS;
        item.intf_tx         = 0;
        mbx.put(item);
      end

      forever begin
        uart_rsp_item item;
        item                 = new();
        intf.recv_tx(item.data, item.parity);
        item.baud_rate       = intf.BAUD_RATE;
        item.parity_enable   = intf.PARITY_ENABLE;
        item.parity_type     = intf.PARITY_TYPE;
        item.second_stop_bit = intf.SECOND_STOP_BIT;
        item.data_bits       = intf.DATA_BITS;
        item.intf_tx         = 1;
        mbx.put(item);
      end

    join_none

  endtask

  task automatic wait_till_idle(input int tx_len = 3);
    intf.wait_till_idle(tx_len);
  endtask

endclass

`endif
