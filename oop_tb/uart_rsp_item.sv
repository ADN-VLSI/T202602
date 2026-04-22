`include "uart_seq_item.sv"

`ifndef __GUARD_UART_RSP_ITEM_SV__
`define __GUARD_UART_RSP_ITEM_SV__ 0

class uart_rsp_item extends uart_seq_item;

  logic parity;

  virtual function string to_string();
    string txt_out;
    txt_out = super.to_string();
    $sformat(txt_out, "%s, parity=%b", txt_out, parity);
    txt_out = txt_out.substr(8, txt_out.len()-1);
    txt_out = {"UART RSP", txt_out};
    return txt_out;
  endfunction

endclass

`endif
