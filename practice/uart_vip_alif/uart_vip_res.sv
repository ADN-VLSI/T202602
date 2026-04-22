`ifndef __GUARD_UART_RSP_ITEM_SV__
`define __GUARD_UART_RSP_ITEM_SV__ 0

class uart_rsp_item extends uart_seq_item;

  // ================= STATUS FLAGS =================
  bit data_valid;
  bit parity_error;
  bit framing_error;


  // ================= DISPLAY =================
  function string to_string();

    return $sformatf(
      "[UART_RSP] DATA=%h TX=%b BAUD=%0d PAR_EN=%b PAR_TYP=%b | VALID=%b PAR_ERR=%b FRM_ERR=%b",
      data, is_tx, baud_div, parity_en, parity_type,
      data_valid, parity_error, framing_error
    );

  endfunction

endclass

`endif