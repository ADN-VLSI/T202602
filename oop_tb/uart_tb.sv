`include "addr_def.sv"

`include "apb_seq_item.sv"
`include "apb_rsp_item.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"

`include "uart_seq_item.sv"
`include "uart_rsp_item.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"

module uart_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // LCOAL PARAMETER DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int debug = 1;

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
  apb_driver apb_dvr;
  apb_monitor apb_mon;

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
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task automatic apb_write(int addr, int data);
    automatic apb_seq_item item;
    item = new();
    item.addr = addr;
    item.write = 1;
    item.data = data;
    apb_dvr_mbx.put(item);
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURAL BLOCKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    automatic int pass;
    automatic int fail;
    automatic int num_rx;

    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);
    $timeformat(-3, 2, "ms");

    apb_dvr_mbx = new(1);
    apb_dvr = new(apb_intf, apb_dvr_mbx);

    apb_mon_mbx = new();
    apb_mon = new(apb_intf, apb_mon_mbx);

    uart_dvr_mbx = new(1);
    uart_dvr = new(uart_intf, uart_dvr_mbx);

    uart_mon_mbx = new();
    uart_mon = new(uart_intf, uart_mon_mbx);


    ctrl_intf.apply_reset();
    apb_dvr.reset();

    ctrl_intf.enable_clock();
    apb_dvr.run();
    apb_mon.run();
    uart_dvr.run();
    uart_mon.run();

    uart_intf.DATA_BITS = 'd8;

    begin
      bit [7:0] tx_q        [$];
      bit [7:0] rx_q        [$];
      bit       tx_flushing;
      bit       rx_flushing;
      fork

        forever begin  // APB INTF
          apb_rsp_item item;
          apb_mon_mbx.get(item);

          if (!item.slverr) begin

            if (item.write) begin  // APB WRITE
              case (item.addr)

                `CTRL_ADDR: begin
                  if (item.data[1]) begin
                    tx_q.delete();
                    tx_flushing = 1;
                    if (debug) $display("\033[1;34mFlushing TX FIFO\033[0m");
                  end else begin
                    tx_flushing = 0;
                    if (debug) $display("\033[1;34mTX FIFO flush disabled\033[0m");
                  end
                  if (item.data[2]) begin
                    rx_q.delete();
                    rx_flushing = 1;
                    if (debug) $display("\033[1;34mFlushing RX FIFO\033[0m");
                  end else begin
                    rx_flushing = 0;
                    if (debug) $display("\033[1;34mRX FIFO flush disabled\033[0m");
                  end
                end

                `CLK_DIV_ADDR: begin
                  if (debug) $display("\033[1;34mSetting clock divider to %0d\033[0m", item.data);
                  uart_intf.BAUD_RATE = 100e6 / item.data;
                  if (debug)
                    $display("\033[1;34mEffective baud rate: %0d\033[0m", uart_intf.BAUD_RATE);
                end

                `CFG_ADDR: begin
                  uart_intf.PARITY_ENABLE = item.data[0];
                  if (debug)
                    $display("\033[1;34mParity %s\033[0m", item.data[0] ? "enabled" : "disabled");

                  uart_intf.PARITY_TYPE = item.data[1];
                  if (debug)
                    $display("\033[1;34mParity type %s\033[0m", item.data[1] ? "odd" : "even");

                  uart_intf.SECOND_STOP_BIT = item.data[2];
                  if (debug)
                    $display(
                        "\033[1;34mSecond stop bit %s\033[0m", item.data[2] ? "enabled" : "disabled"
                    );
                end

                `TX_FIFO_COUNT_ADDR, `RX_FIFO_COUNT_ADDR, `RX_DATA_ADDR: begin
                  $fatal(1, "Write shouldn't succeed in this address 0x%x", item.addr);
                end

                `TX_DATA_ADDR: begin
                  tx_q.push_back(item.data[7:0]);
                  if (debug)
                    $display(
                        "\033[1;34mWritten 0x%0h (%s) to TX FIFO\033[0m",
                        item.data[7:0],
                        item.data[7:0]
                    );
                end

              endcase

            end else begin  // APB READ

              case (item.addr)

                `TX_DATA_ADDR: begin
                  $fatal(1, "Read shouldn't succeed in this address 0x%x", item.addr);
                end

                `RX_DATA_ADDR: begin
                  if (item.data[7:0] == rx_q[0]) begin
                    $error("RX data mismatch! Expected 0x%0h (%b) but got 0x%0h (%b)", rx_q[0],
                           rx_q[0], item.data[7:0], item.data[7:0]);
                    fail++;
                  end else begin
                    if (debug) begin
                      $display("\033[1;35mRead 0x%0h (%s) from RX FIFO <<\033[0m", item.data[7:0],
                               item.data[7:0]);
                      $display("\033[1;35m|||| 0x%0h (%s)\033[0m", rx_q[0],
                               rx_q[0]);  // TODO REMOVE
                    end
                    pass++;
                  end
                  rx_q.delete(0);
                end

                `RX_FIFO_COUNT_ADDR: begin
                  num_rx = item.data;
                  if (debug) $display("\033[1;35mRead RX FIFO count: %0d\033[0m", item.data);
                end

              endcase
            end

          end

        end

        forever begin  // UART INTF
          uart_rsp_item item;
          uart_mon_mbx.get(item);
          item.print();

          if (item.intf_tx) begin  // TB TX -> DUT RX
            rx_q.push_back(item.data);
            if (debug)
              $display("\033[1;32mReceived 0x%0h (%s) by UART\033[0m", item.data, item.data);

          end else begin  // DUT TX -> TB RX

              if (tx_q[0] !== item.data) begin
                $error("TX data mismatch! Expected 0x%0h but got 0x%0h", tx_q[0], item.data);
                fail++;
              end else begin
                if (debug)
                  $display("\033[1;32mTransmitted 0x%0h (%s) from DUT\033[0m", item.data, item.data);
                pass++;
              end
              tx_q.delete(0);

          end
        end

      join_none
    end

    $display("\033[1;33mScoreboard Started\033[0m %0t", $realtime);

    apb_write(`CTRL_ADDR, 'b110);  // flush all
    apb_write(`CTRL_ADDR, 'b000);  // disable flush  
    apb_write(`CLK_DIV_ADDR, 'd100);  // set clock divider
    apb_write(`CTRL_ADDR, 'b001);  // enable clock

    $display("\033[1;33mConfiguration Done\033[0m %0t", $realtime);

    begin
      automatic string dut_tx_string = "Hello Ratul, Sabbir & Alif bhai..! :)";
      for (int i = 0; i < dut_tx_string.len(); i++) begin
        apb_write(`TX_DATA_ADDR, dut_tx_string[i]);
      end
    end

    $display("\033[1;33mWaiting for DUT Transmission to complete\033[0m %0t", $realtime);

    apb_mon.wait_till_idle();
    uart_mon.wait_till_idle();

    $display("\033[1;33mDUT Transmission to completed\033[0m %0t", $realtime);

    $display("\033[1;33mTB Transmitting\033[0m %0t", $realtime);

    begin
      automatic string dut_rx_string = "Hi everyone..! :)";
      for (int i = 0; i < dut_rx_string.len(); i++) begin
        uart_seq_item item;
        item = new();
        item.data = dut_rx_string[i];  // only the least significant byte will be considered
        item.baud_rate = uart_intf.BAUD_RATE;
        item.parity_enable = uart_intf.PARITY_ENABLE;
        item.parity_type = uart_intf.PARITY_TYPE;
        item.second_stop_bit = uart_intf.SECOND_STOP_BIT;
        item.data_bits = uart_intf.DATA_BITS;
        uart_dvr_mbx.put(item);
      end
    end

    $display("\033[1;33mWaiting for DUT Reception to complete\033[0m %0t", $realtime);

    apb_mon.wait_till_idle();
    uart_mon.wait_till_idle();

    $display("\033[1;33mDUT Reception to completed\033[0m %0t", $realtime);

    begin
      apb_seq_item item;
      item = new();
      item.write = 0;
      item.addr = `RX_FIFO_COUNT_ADDR;
      apb_dvr_mbx.put(item);
    end

    $display("\033[1;33mReading number of bytes in RX FIFO\033[0m %0t", $realtime);
    apb_mon.wait_till_idle();

    begin
      $display("\033[1;33mNumber of bytes in RX FIFO: %0d\033[0m %0t", num_rx, $realtime);
      repeat (num_rx) begin
        apb_seq_item item;
        item = new();
        item.write = 0;
        item.addr = `RX_DATA_ADDR;
        apb_dvr_mbx.put(item);
      end
    end

    $display("\033[1;33mReading bytes from RX FIFO\033[0m %0t", $realtime);

    apb_mon.wait_till_idle();
    uart_mon.wait_till_idle();

    $display("\033[1;33mScoreboard Finished\033[0m %0t", $realtime);

    #100ns;

    if (fail == 0) begin
      $display("\033[1;32mTEST PASSED...! %0d/%0d OK\033[0m", pass, pass + fail);
    end else begin
      $display("\033[1;31mTEST FAILED...! %0d/%0d OK\033[0m", pass, pass + fail);
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
