`ifndef __GUARD_UART_SEQ_ITEM_SV__
`define __GUARD_UART_SEQ_ITEM_SV__ 0

class uart_seq_item;

  // ================= FIELDS =================
  rand bit [7:0]  data;
  rand bit        is_tx;
  rand bit [15:0] baud_div;
  rand bit        parity_en;
  rand bit        parity_type;

  int delay;


  // ================= CONSTRAINTS =================
  constraint data_c {
    data inside {[8'h00:8'hFF]};
  }

  constraint baud_c {
    baud_div inside {[16'd1:16'd1000]};
  }


  // ================= DISPLAY =================
  function string to_string();

    return $sformatf(
      "[UART_SEQ] DATA=%h TX=%b BAUD=%0d PAR_EN=%b PAR_TYP=%b",
      data, is_tx, baud_div, parity_en, parity_type
    );

  endfunction


  // ================= PRINT =================
  function void print();
    $display("%s", to_string());
  endfunction


endclass

`endif