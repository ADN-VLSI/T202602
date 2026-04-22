`include "uart_seq_item.sv"

`ifndef __GUARD_UART_DRIVER_SV__
`define __GUARD_UART_DRIVER_SV__ 0

class uart_driver;

  virtual uart_if intf;

  mailbox #(uart_seq_item) mbx;

  function new(virtual uart_if intf, mailbox #(uart_seq_item) mbx);
    this.intf = intf;
    this.mbx = mbx;
  endfunction

  task automatic run();
    uart_seq_item item;

    fork

      forever begin
        mbx.peek(item);
        intf.send_tx(item.data, item.baud_rate, item.parity_enable,
                     item.parity_type, item.second_stop_bit, item.data_bits);
        mbx.get(item);
      end

    join_none

  endtask

endclass

`endif
