`include "apb_seq_item.sv"
`include "apb_rsp_item.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "addr_def.sv"
`include "uart_seq_item.sv"
`include "uart_rsp_item.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"

module uart_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNAL DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERFACE INSTANCES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ctrl_if ctrl_intf ();

  apb_if apb_intf (
      .arst_ni(ctrl_intf.arst_ni),
      .clk_i  (ctrl_intf.clk_i)
  );

  uart_if uart_intf ();

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // CLASS INSTANCES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  mailbox #(apb_seq_item) apb_dvr_mbx;
  mailbox #(apb_rsp_item) apb_mon_mbx;
  apb_driver dvr;
  apb_monitor mon;

  mailbox #(uart_seq_item) uart_dvr_mbx;
  mailbox #(uart_rsp_item) uart_mon_mbx;
  uart_driver uart_dvr;
  uart_monitor uart_mon;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // DUT INSTANCES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  uart_top dut (
      .arst_ni(ctrl_intf.arst_ni),
      .clk_i(ctrl_intf.clk_i),
      .psel_i(apb_intf.psel),
      .penable_i(apb_intf.penable),
      .paddr_i(apb_intf.paddr),
      .pwrite_i(apb_intf.pwrite),
      .pwdata_i(apb_intf.pwdata),
      .pstrb_i(apb_intf.pstrb),
      .pready_o(apb_intf.pready),
      .prdata_o(apb_intf.prdata),
      .pslverr_o(apb_intf.pslverr),
      .rx_i(uart_intf.tx),
      .tx_o(uart_intf.rx),
      .irq_tx_almost_full(irq_tx_almost_full),
      .irq_rx_almost_full(irq_rx_almost_full),
      .irq_rx_parity_error(irq_rx_parity_error),
      .irq_rx_valid(irq_rx_valid)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURAL BLOCKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);
    $timeformat(-3, 2, "ms");

    apb_dvr_mbx = new(1);
    dvr = new(apb_intf, apb_dvr_mbx);

    apb_mon_mbx = new();
    mon = new(apb_intf, apb_mon_mbx);

    uart_dvr_mbx = new(1);
    uart_dvr = new(uart_intf, uart_dvr_mbx);

    uart_mon_mbx = new();
    uart_mon = new(uart_intf, uart_mon_mbx);


    ctrl_intf.apply_reset();
    dvr.reset();

    ctrl_intf.enable_clock();
    dvr.run();
    mon.run();
    uart_dvr.run();
    uart_mon.run();

    begin
      automatic apb_seq_item seq_item;
      seq_item = new();
      seq_item.randomize();
      apb_dvr_mbx.put(seq_item);
      seq_item = new seq_item;
      seq_item.write = 0;
      apb_dvr_mbx.put(seq_item);
    end

    begin
      automatic uart_seq_item uart_seq;
      uart_seq = new();
      uart_seq.randomize();
      uart_dvr_mbx.put(uart_seq);
    end
    
    mon.wait_till_idle();
    uart_mon.wait_till_idle();

    while (apb_mon_mbx.num()) begin
      apb_rsp_item item;
      apb_mon_mbx.get(item);
      item.print();
    end

    while (uart_mon_mbx.num()) begin
      uart_rsp_item item;
      uart_mon_mbx.get(item);
      item.print();
    end

    $finish;
  end

  initial begin
    fork
      forever begin
        #10us;
        $display("  %0t       \033[1A\033[0G", $realtime);
      end
    join_none
    #10ms;
    $fatal(1, "\033[1;31mTEST TIMED OUT\033[0m");
  end

endmodule
