`ifndef __GUARD_UART_MONITOR_SV__
`define __GUARD_UART_MONITOR_SV__ 0

`include "obj/uart_rsp_item.sv"

class uart_monitor extends uvm_monitor;

  `uvm_component_utils(uart_monitor)

  virtual uart_if uart_intf;

  uvm_analysis_port #(uart_rsp_item) ap;

  function new(string name = "uart_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(uvm_root::get(), "uart", "uart_intf", uart_intf)) begin
      `uvm_fatal("NOVIF", "Virtual interface 'uart_intf' not found in config DB")
    end
  endfunction

    task run_phase(uvm_phase phase);
    uart_rsp_item rsp_tx;
    uart_rsp_item rsp_rx;
    fork
      // Interface TX transactions
      forever begin
        @(negedge vif.tx);
        rsp_tx = uart_rsp_item::type_id::create("rsp_tx");
        vif.recv_tx(rsp_tx.data, rsp_tx.parity, baud_rate, parity_enable, parity_type, second_stop_bit, data_bits);
        rsp_tx.intf_tx = 1;  // TX direction
        rsp_tx.baud_rate = baud_rate;
        rsp_tx.parity_enable = parity_enable;
        rsp_tx.parity_type = parity_type;
        rsp_tx.second_stop_bit = second_stop_bit;
        rsp_tx.data_bits = data_bits;
        ap.write(rsp_tx);
      end
      // Interface RX transactions
      forever begin
        @(negedge vif.rx);
        rsp_rx = uart_rsp_item::type_id::create("rsp_rx");
        vif.recv_rx(rsp_rx.data, rsp_rx.parity, baud_rate, parity_enable, parity_type, second_stop_bit, data_bits);
        rsp_rx.intf_tx = 0;  // RX direction
        rsp_rx.baud_rate = baud_rate;
        rsp_rx.parity_enable = parity_enable;
        rsp_rx.parity_type = parity_type;
        rsp_rx.second_stop_bit = second_stop_bit;
        rsp_rx.data_bits = data_bits;
        ap.write(rsp_rx);
      end
    join
  endtask

endclass

`endif
