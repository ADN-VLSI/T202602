`ifndef __GUARD_UART_SEQ_ITEM_SV__
`define __GUARD_UART_SEQ_ITEM_SV__ 0

class uart_seq_item;

  rand logic [7:0] data;
  rand int         baud_rate       = 115200;
  rand bit         parity_enable   = 0;
  rand bit         parity_type     = 1;  // 0=even, 1=odd
  rand bit         second_stop_bit = 0;
  rand int         data_bits       = 8;

  constraint data_c {
    baud_rate inside {9600, 19200, 38400, 57600, 115200};
  }

  constraint data_bits_c {
    data_bits inside {8}; // TODO LATER
    // data_bits inside {5, 6, 7, 8};
  }

  virtual function string to_string();
    return $sformatf(
        "UART SEQ ITEM: data=0x%0h, baud_rate=%0d, parity_enable=%b, parity_type=%b, second_stop_bit=%b, data_bits=%0d",
        data, baud_rate, parity_enable, parity_type, second_stop_bit, data_bits);
  endfunction

  virtual function void print();
    $display("%s", this.to_string());
  endfunction

endclass

`endif
