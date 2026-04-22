`ifndef __GUARD_UART_CFG_SV__
`define __GUARD_UART_CFG_SV__ 0

class uart_cfg;

  // ================= DEFAULT CONFIG =================
  bit [15:0] baud_div   = 16'd868;
  bit        parity_en  = 1'b0;
  bit        parity_type= 1'b0; // 0-even, 1-odd
  bit        stop_bits  = 1'b0; // 0=1 stop, 1=2 stop
  bit [2:0]  data_bits  = 3'd8;


  // ================= CONSTRUCTOR =================
  function new();
  endfunction


  // ================= BAUD RATE =================
  function void set_baud_rate(bit [15:0] baud_div);
    this.baud_div = baud_div;
  endfunction

  function bit [15:0] get_baud_rate();
    return this.baud_div;
  endfunction


  // ================= PARITY =================
  function void set_parity(bit enable, bit ptype);
    this.parity_en   = enable;
    this.parity_type = ptype;
  endfunction

  function void get_parity(output bit enable,
                           output bit ptype);
    enable = this.parity_en;
    ptype  = this.parity_type;
  endfunction


  // ================= DATA BITS =================
  function void set_data_bits(bit [2:0] bits);

    if(bits >= 3'd5 && bits <= 3'd8)
      this.data_bits = bits;
    else
      $warning("[UART_CFG] Invalid data bits = %0d (default 8 used)", bits);

  endfunction

  function bit [2:0] get_data_bits();
    return this.data_bits;
  endfunction


  // ================= PRINT =================
  function void print();

    $display("========== UART CONFIG ==========");
    $display(" Baud Rate  : %0d", baud_div);
    $display(" Parity En  : %0b", parity_en);
    $display(" Parity Typ : %0b (0-even,1-odd)", parity_type);
    $display(" Stop Bits  : %0b (0-1,1-2)", stop_bits);
    $display(" Data Bits  : %0d", data_bits);
    $display("=================================");

  endfunction

endclass

`endif