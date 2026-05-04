`ifndef __GUARD_UART_DRIVER_SV__
`define __GUARD_UART_DRIVER_SV__ 0

`include "obj/uart_seq_item.sv"

class uart_driver extends uvm_driver #(uart_seq_item);

  `uvm_component_utils(uart_driver)

  virtual uart_if uart_intf;

  function new(string name = "uart_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(uvm_root::get(), "uart", "uart_intf", uart_intf)) begin
      `uvm_fatal("NOVIF", "Virtual interface 'uart_intf' not found in config DB")
    end
  endfunction

  task run_phase(uvm_phase phase);
    uart_seq_item req;
    forever begin
      seq_item_port.get_next_item(req);
      uart_intf.send_tx(req.data);
      seq_item_port.item_done();
    end
  endtask

endclass

`endif
