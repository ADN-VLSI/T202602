`ifndef __GUARD_APB_DRIVER_SV__
`define __GUARD_APB_DRIVER_SV__ 0

`include "obj/apb_seq_item.sv"

class apb_driver extends uvm_driver #(apb_seq_item);

  `uvm_component_utils(apb_driver)

  virtual apb_if apb_intf;

  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(uvm_root::get(), "apb", "apb_intf", apb_intf)) begin
      `uvm_fatal("NOVIF", "Virtual interface 'apb_intf' not found in config DB")
    end
  endfunction

  task run_phase(uvm_phase phase);
    apb_seq_item req;
    forever begin
      seq_item_port.get_next_item(req);
      if(req.write) begin
        apb_intf.write(req.addr, req.data);
      end else begin
        int read_data;
        apb_intf.read(req.addr, read_data);
      end
      seq_item_port.item_done();
    end
  endtask

endclass

`endif
