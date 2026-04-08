# APB UART Register Interface (`apb_uart_regif`)

## Overview
`apb_uart_regif` is an APB3-compatible UART register interface for FPGA/ASIC designs.  
It allows controlling a UART peripheral through registers, handling transmission, reception, and baud rate configuration.  

The repository includes a SystemVerilog testbench (`tb_apb_uart_regif`) to verify the module.

---

## Features
- APB3 compliant interface
- UART enable/disable control
- Baud rate configuration
- TX data write with `tx_start` pulse generation
- RX data capture with `rx_valid`
- Status register for TX ready and RX valid
- Fully synthesizable

---

## Register Map

| Address     | Name       | Description                                  |
|------------|------------|----------------------------------------------|
| 0x00       | CTRL       | Control register (bit 0 = uart_en)          |
| 0x04       | STATUS     | Status register (bit 0 = tx_ready, bit 1 = rx_valid) |
| 0x08       | TXDATA     | TX data register (writing triggers `tx_start`) |
| 0x0C       | RXDATA     | RX data register (captured on `rx_valid`)   |
| 0x10       | BAUDDIV    | Baud rate divider (16-bit active)           |

---

## Ports

### APB Interface
| Port      | Direction | Width | Description                    |
|-----------|-----------|-------|--------------------------------|
| pclk      | input     | 1     | APB clock                      |
| presetn   | input     | 1     | Active low reset               |
| psel      | input     | 1     | APB select                     |
| penable   | input     | 1     | APB enable                     |
| paddr     | input     | 8     | APB address                    |
| pwrite    | input     | 1     | APB write enable               |
| pwdata    | input     | 32    | APB write data                 |
| pstrb     | input     | 4     | APB write strobe               |
| pready    | output    | 1     | APB ready                      |
| prdata    | output    | 32    | APB read data                  |
| pslverr   | output    | 1     | APB error                      |

### UART Interface
| Port       | Direction | Width | Description                     |
|------------|-----------|-------|---------------------------------|
| uart_en    | output    | 1     | UART enable                     |
| tx_start   | output    | 1     | Pulse to start TX               |
| tx_data    | output    | 8     | Data to transmit                |
| rx_data    | input     | 8     | Data received                   |
| rx_valid   | input     | 1     | RX data valid                   |
| tx_ready   | input     | 1     | TX ready                        |
| baud_div   | output    | 16    | UART baud rate divider          |

---

## Testbench

The `tb_apb_uart_regif.sv` testbench covers:

- Reset and initialization  
- Writing CTRL register to enable UART  
- Writing BAUDDIV register  
- Writing TXDATA and generating `tx_start` pulse  
- Reading STATUS register  
- Simulating RX event and reading RXDATA  

### Example Console Output

```text
=== APB UART REGIF TEST START ===
CTRL written, uart_en = 1
BAUDDIV written, baud_div = 52
TXDATA written, tx_data = 0xA5, tx_start = 1
STATUS read = 0x00000001
RXDATA read = 0x0000003C
=== TEST END ===