`ifndef __GUARD_UART_TOP_ENV_SV__
`define __GUARD_UART_TOP_ENV_SV__ 0

`include "cmp/apb_agent.sv"
`include "cmp/uart_agent.sv"
`include "cmp/uart_top_scbd.sv"

class uart_top_env extends uvm_env;

  // UVM component utilities for factory registration
  `uvm_component_utils(uart_top_env)

  apb_agent     apb;
  uart_agent    uart;
  uart_top_scbd scbd;

  // Constructor for the environment
  function new(string name = "uart_top_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb  = apb_agent::type_id::create("apb", this);
    uart = uart_agent::type_id::create("uart", this);
    scbd = uart_top_scbd::type_id::create("scbd", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb.ap.connect(scbd.m_analysis_imp_apb);
    uart.ap.connect(scbd.m_analysis_imp_uart);
  endfunction

endclass

`endif
