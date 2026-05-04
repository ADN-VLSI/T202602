`ifndef __GUARD_APB_MONITOR_SV__
`define __GUARD_APB_MONITOR_SV__ 0

`include "obj/apb_rsp_item.sv"

class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)

  virtual apb_if apb_intf;

  uvm_analysis_port #(apb_rsp_item) ap;

  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(uvm_root::get(), "apb", "apb_intf", apb_intf)) begin
      `uvm_fatal("NOVIF", "Virtual interface 'apb_intf' not found in config DB")
    end
  endfunction

  task run_phase(uvm_phase phase);
    apb_rsp_item rsp;
    int direction;
    int address;
    int write_data;
    int write_strobe;
    int read_data;
    int slverr;

    forever begin
      // Get the next transaction from the interface
      apb_intf.get_transaction(direction, address, write_data, write_strobe, read_data, slverr);
      // Create a response item and populate its fields
      rsp = apb_rsp_item::type_id::create("rsp");
      rsp.addr   = address;
      rsp.write  = direction;
      rsp.data   = direction ? write_data : read_data;
      rsp.slverr = slverr;
      // Send the response item via the analysis port
      ap.write(rsp);
    end
  endtask

endclass

`endif
