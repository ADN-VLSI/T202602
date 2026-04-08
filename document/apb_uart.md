# APB-UART

## Overview

The APB-UART peripheral is a Universal Asynchronous Receiver/Transmitter (UART) designed for serial communication in embedded systems. It interfaces with the Advanced Peripheral Bus (APB) and provides configurable options for baud rate, parity, and stop bits. The peripheral includes transmit and receive FIFOs to buffer data, enhancing communication efficiency.

## Functional Specification

The APB-UART peripheral provides a standard UART interface for serial communication. It supports configurable baud rates, parity settings, and includes transmit and receive FIFOs to buffer data. Key features include:

- Transmission
- Reception
- Programmable Baud Rate
- Programmable Parity
- 1KB of TX Buffer
- 1KB of RX Buffer

## Top-Level Black box Diagram

The following diagram illustrates the top-level architecture of the APB-UART peripheral, showing its main components and their interconnections.

![TOP_IO](svg/top.svg)

## Parameters

The APB-UART peripheral is parameterized to allow customization of its data and address widths. The following parameters are defined:

| Parameter  | Description              | Default Value |
| ---------- | ------------------------ | ------------- |
| DATA_WIDTH | Width of the data bus    | 32            |
| ADDR_WIDTH | Width of the address bus | 8             |

## Interface Specification

The APB-UART peripheral interfaces with the APB bus and provides UART signals for serial communication. The following table summarizes the input and output signals of the peripheral:

| Signal Name         | Direction | Width        | Description                                 |
| ------------------- | --------- | ------------ | ------------------------------------------- |
| arst_ni             | Input     | 1            | Asynchronous reset, active low              |
| clk_i               | Input     | 1            | System clock input                          |
| psel_i              | Input     | 1            | APB select signal                           |
| penable_i           | Input     | 1            | APB enable signal                           |
| paddr_i             | Input     | ADDR_WIDTH   | APB address bus                             |
| pwrite_i            | Input     | 1            | APB write signal                            |
| pwdata_i            | Input     | DATA_WIDTH   | APB write data bus                          |
| pstrb_i             | Input     | DATA_WIDTH/8 | APB write strobe                            |
| pready_o            | Output    | 1            | APB ready signal                            |
| prdata_o            | Output    | DATA_WIDTH   | APB read data bus                           |
| pslverr_o           | Output    | 1            | APB slave error signal                      |
| rx_i                | Input     | 1            | UART receive data input                     |
| tx_o                | Output    | 1            | UART transmit data output                   |
| irq_tx_almost_full  | Output    | 1            | Interrupt for TX FIFO almost full condition |
| irq_rx_almost_full  | Output    | 1            | Interrupt for RX FIFO almost full condition |
| irq_rx_parity_error | Output    | 1            | Interrupt for RX parity error condition     |
| irq_rx_valid        | Output    | 1            | Interrupt for RX data valid condition       |

## APB-UART Register Map and Configuration

This document describes the register map and configuration options for the APB-UART (Advanced Peripheral Bus - Universal Asynchronous Receiver/Transmitter) peripheral. The UART implements a standard serial communication interface with configurable baud rate, parity, and stop bits, along with transmit and receive FIFOs.

### Register Summary

| Register      | Access | Address | Reset Value | Description                                                 |
| ------------- | ------ | ------- | ----------- | ----------------------------------------------------------- |
| CTRL          | RW     | 0x00    | 0x0         | Control register for clock enable and FIFO flush operations |
| CLK_DIV       | RW     | 0x04    | 0x28B0      | Clock divider register for baud rate generation             |
| CFG           | RW     | 0x08    | 0x0         | UART configuration register for parity and stop bits        |
| TX_FIFO_COUNT | RO     | 0x0C    | 0x0         | Transmit FIFO data count (read-only)                        |
| RX_FIFO_COUNT | RO     | 0x10    | 0x0         | Receive FIFO data count (read-only)                         |
| TX_DATA       | WO     | 0x14    | 0x0         | Transmit data register (write-only)                         |
| RX_DATA       | RO     | 0x18    | 0x0         | Receive data register (read-only)                           |
| INTR_CTRL     | RW     | 0x1C    | 0x0         | Interrupt control register                                  |

### Register Details

#### CTRL (0x00) - Control Register

Controls the basic operation of the UART peripheral, including clock enable and FIFO management.

| Bit Field | Access | Index | Reset Value | Description                                                   |
| --------- | ------ | ----- | ----------- | ------------------------------------------------------------- |
| CLK_EN    | RW     | 0     | 0x0         | Clock Enable: 1 = Enable UART clock, 0 = Disable UART clock   |
| TX_FLUSH  | RW     | 1     | 0x0         | Transmit FIFO Flush: Write 1 to clear TX FIFO (self-clearing) |
| RX_FLUSH  | RW     | 2     | 0x0         | Receive FIFO Flush: Write 1 to clear RX FIFO (self-clearing)  |
| RESERVED  | \--    | 31:3  | 0x0         | Reserved for future use                                       |

#### CLK_DIV (0x04) - Clock Divider Register

Configures the baud rate by dividing the input clock. The baud rate is calculated as: `Baud Rate = APB_Clock / (DIVIDER + 1)`.

Default value of 0x28B0 (9600) provides a baud rate of 9600 when using a 100 MHz APB clock.

| Bit Field | Access | Index | Reset Value | Description                                  |
| --------- | ------ | ----- | ----------- | -------------------------------------------- |
| DIVIDER   | RW     | 31:0  | 0x28B0      | Clock divider value for baud rate generation |

#### CFG (0x08) - Configuration Register

Configures UART frame format including parity and stop bit settings.

| Bit Field   | Access | Index | Reset Value | Description                                                                  |
| ----------- | ------ | ----- | ----------- | ---------------------------------------------------------------------------- |
| PARITY_EN   | RW     | 0     | 0x0         | Parity Enable: 1 = Enable parity bit, 0 = Disable parity                     |
| PARITY_TYPE | RW     | 1     | 0x0         | Parity Type: 1 = Odd parity, 0 = Even parity (only valid when PARITY_EN = 1) |
| EXTRA_STOP  | RW     | 2     | 0x0         | Stop Bits: 1 = Two stop bits, 0 = One stop bit                               |
| RESERVED    | \--    | 31:3  | 0x0         | Reserved for future use                                                      |

#### TX_FIFO_COUNT (0x0C) - Transmit FIFO Count Register

Read-only register that indicates the number of bytes currently in the transmit FIFO.

| Bit Field | Access | Index | Reset Value | Description                                           |
| --------- | ------ | ----- | ----------- | ----------------------------------------------------- |
| COUNT     | RO     | 31:0  | 0x0         | Number of bytes currently stored in the transmit FIFO |

#### RX_FIFO_COUNT (0x10) - Receive FIFO Count Register

Read-only register that indicates the number of bytes currently in the receive FIFO.

| Bit Field | Access | Index | Reset Value | Description                                          |
| --------- | ------ | ----- | ----------- | ---------------------------------------------------- |
| COUNT     | RO     | 31:0  | 0x0         | Number of bytes currently stored in the receive FIFO |

#### TX_DATA (0x14) - Transmit Data Register

Write-only register for transmitting data. Writing a byte to this register adds it to the transmit FIFO. Software should check TX_FIFO_COUNT or interrupt status before writing to avoid overflow.

| Bit Field | Access | Index | Reset Value | Description                    |
| --------- | ------ | ----- | ----------- | ------------------------------ |
| DATA      | WO     | 7:0   | \--         | Data byte to transmit (8 bits) |
| RESERVED  | \--    | 31:8  | \--         | Reserved, writes ignored       |

#### RX_DATA (0x18) - Receive Data Register

Read-only register for receiving data. Reading from this register removes the oldest byte from the receive FIFO. Software should check RX_FIFO_COUNT or interrupt status before reading to ensure data is available.

| Bit Field | Access | Index | Reset Value | Description                 |
| --------- | ------ | ----- | ----------- | --------------------------- |
| DATA      | RO     | 7:0   | 0x0         | Received data byte (8 bits) |
| RESERVED  | \--    | 31:8  | 0x0         | Reserved, always reads 0    |

#### INTR_CTRL (0x1C) - Interrupt Control Register

Controls interrupt enables and provides status flags for various UART conditions. Writing 1 to a status bit clears the interrupt flag.

| Bit Field       | Access | Index | Reset Value | Description                                                                         |
| --------------- | ------ | ----- | ----------- | ----------------------------------------------------------------------------------- |
| RX_VALID        | RW     | 0     | 0x0         | Receive Data Valid: Set when data is available in RX FIFO, write 1 to clear         |
| RX_PARITY_ERROR | RW     | 1     | 0x0         | Receive Parity Error: Set when parity error detected, write 1 to clear              |
| RX_ALMOST_FULL  | RW     | 2     | 0x0         | Receive FIFO Almost Full: Set when RX FIFO reaches threshold, write 1 to clear      |
| TX_ALMOST_FULL  | RW     | 3     | 0x0         | Transmit FIFO Almost Full: Set when TX FIFO falls below threshold, write 1 to clear |
| RESERVED        | \--    | 31:4  | 0x0         | Reserved for future use                                                             |

## Block Diagram

The following diagrams illustrate the internal architecture and key components of the APB-UART peripheral.

![Micro Architecture](svg/march.svg)

- [**apb_memif:**](#apb_memif) This module serves as the interface between the APB bus and the UART's internal registers and FIFOs. It handles APB read and write transactions, manages register access, and coordinates data flow to and from the transmit and receive FIFOs.
- [**uart_regif:**](#uart_regif) Updated register interface that fronts the APB-facing memory requests, maps them into typed control/status registers, and handshakes TX/RX data and interrupt signals with the core.
- [**cdc_fifo:**](#cdc_fifo) Clock domain crossing FIFO (renamed diagram from `cdc_fifo_top` to `cdc_fifo`) that protects TX and RX paths when traversing between APB and UART clock domains.
- [**clk_div:**](#clk_div) This module generates the appropriate baud rate clock by dividing the input clock based on the configured clock divider value. It provides timing signals for UART data transmission and reception.
- [**uart_tx:**](#uart_tx) This module handles the transmission of data over the UART interface. It manages the serialization of data bytes, adds start, stop, and parity bits as configured, and controls the timing of data output on the TX line.
- [**uart_rx:**](#uart_rx) This module manages the reception of data from the UART interface. It detects start and stop bits, checks for parity errors, and deserializes incoming data bytes for storage in the RX FIFO.

## Detailed Design

### apb_memif

The `apb_memif` module serves as the bridge between the APB bus and the UART's internal registers and FIFOs. It handles APB read and write transactions, manages register access, and coordinates data flow to and from the transmit and receive FIFOs. It ensures proper timing and synchronization for data transfers, adhering to the APB protocol specifications. The following diagram illustrates the internal structure of the `apb_memif` module:

![apb_memif](svg/apb_memif.svg)

#### Parameters

| Parameter  | Description              | Default Value |
| ---------- | ------------------------ | ------------- |
| DATA_WIDTH | Width of the data bus    | 32            |
| ADDR_WIDTH | Width of the address bus | 32            |

#### Ports

| Port Name | Direction | Width        | Description                       |
| --------- | --------- | ------------ | --------------------------------- |
| arst_ni   | Input     | 1            | Asynchronous reset, active low    |
| clk_i     | Input     | 1            | Clock input                       |
| psel_i    | Input     | 1            | APB select signal                 |
| penable_i | Input     | 1            | APB enable signal                 |
| paddr_i   | Input     | ADDR_WIDTH   | APB address bus                   |
| pwrite_i  | Input     | 1            | APB write signal                  |
| pwdata_i  | Input     | DATA_WIDTH   | APB write data bus                |
| pstrb_i   | Input     | DATA_WIDTH/8 | APB write strobe                  |
| pready_o  | Output    | 1            | APB ready signal                  |
| prdata_o  | Output    | DATA_WIDTH   | APB read data bus                 |
| pslverr_o | Output    | 1            | APB slave error signal            |
| mreq_o    | Output    | 1            | Memory request                    |
| maddr_o   | Output    | ADDR_WIDTH   | Memory address                    |
| mwe_o     | Output    | 1            | Memory write enable               |
| mwdata_o  | Output    | DATA_WIDTH   | Memory write data                 |
| mstrb_o   | Output    | DATA_WIDTH/8 | Memory byte strobe                |
| mack_i    | Input     | 1            | Memory acknowledge                |
| mrdata_i  | Input     | DATA_WIDTH   | Memory read data                  |
| mresp_i   | Input     | 1            | Memory response (error indicator) |

### uart_regif

The `uart_regif` block has been refreshed to match the latest register file implementation. It now translates memory requests from `apb_memif` into typed control, clock divider, and configuration registers, mirrors TX/RX FIFO counts, handshakes TX/RX data transfers, and surfaces interrupt status back to the core. The updated diagram for the replacement register interface is shown below:

![uart_regif](svg/uart_regif.svg)

#### Parameters

| Parameter  | Description              | Default Value |
| ---------- | ------------------------ | ------------- |
| DATA_WIDTH | Width of the data bus    | 32            |
| ADDR_WIDTH | Width of the address bus | 5             |

#### Ports

| Port Name           | Direction | Width               | Description                                       |
| ------------------- | --------- | ------------------- | ------------------------------------------------- |
| arst_ni             | Input     | 1                   | Asynchronous reset, active low                    |
| clk_i               | Input     | 1                   | Clock input                                       |
| mreq_i              | Input     | 1                   | Memory request                                    |
| maddr_i             | Input     | ADDR_WIDTH          | Memory address                                    |
| mwe_i               | Input     | 1                   | Memory write enable                               |
| mwdata_i            | Input     | DATA_WIDTH          | Memory write data                                 |
| mstrb_i             | Input     | DATA_WIDTH/8        | Memory byte strobe                                |
| mack_o              | Output    | 1                   | Memory acknowledge                                |
| mrdata_o            | Output    | DATA_WIDTH          | Memory read data                                  |
| mresp_o             | Output    | 1                   | Memory response (error indicator)                 |
| ctrl_reg_o          | Output    | ctrl_reg_t          | Control register output to UART core              |
| clk_div_reg_o       | Output    | clk_div_reg_t       | Clock divider register output to UART core        |
| cfg_reg_o           | Output    | cfg_reg_t           | Configuration register output to UART core        |
| tx_fifo_count_reg_i | Input     | tx_fifo_count_reg_t | Transmit FIFO count register input from UART core |
| rx_fifo_count_reg_i | Input     | rx_fifo_count_reg_t | Receive FIFO count register input from UART core  |
| tx_data_reg_o       | Output    | tx_data_reg_t       | Transmit data register output to UART core        |
| tx_data_valid_o     | Output    | 1                   | Transmit data valid signal to UART core           |
| tx_data_ready_i     | Input     | 1                   | Transmit data ready signal from UART core         |
| rx_data_reg_i       | Input     | rx_data_reg_t       | Receive data register input from UART core        |
| rx_data_valid_i     | Input     | 1                   | Receive data valid signal from UART core          |
| rx_data_ready_o     | Output    | 1                   | Receive data ready signal to UART core            |
| intr_ctrl_reg_o     | Output    | intr_ctrl_reg_t     | Interrupt control register output to UART core    |

### cdc_fifo

The `cdc_fifo` module implements the clock domain crossing FIFOs used on both TX and RX paths, ensuring data integrity between the APB and UART clock domains. The top-level diagram has been renamed to `cdc_fifo` to reflect the updated drawing. The diagrams below show the refreshed top-level view and the detailed CDC FIFO operation:

![cdc_fifo](svg/cdc_fifo.svg)

![cdc_fifo_description](svg/cdc_fifo_description.svg)

#### Parameters

| Parameter  | Description                | Default Value |
| ---------- | -------------------------- | ------------- |
| ELEM_WIDTH | Width of each FIFO element | 8             |
| FIFO_SIZE  | Size of the FIFO (in bits) | 2             |

#### Ports

| Port Name        | Direction | Width                    | Description                                                          |
| ---------------- | --------- | ------------------------ | -------------------------------------------------------------------- |
| arst_ni          | Input     | 1                        | Asynchronous active-low reset (applies to registers in both domains) |
| elem_in_i        | Input     | ELEM_WIDTH               | Input element to be written into the FIFO (input domain)             |
| elem_in_clk_i    | Input     | 1                        | Clock for input domain                                               |
| elem_in_valid_i  | Input     | 1                        | Valid signal for input element                                       |
| elem_in_ready_o  | Output    | 1                        | Ready signal indicating space in FIFO (input domain)                 |
| elem_in_count_o  | Output    | $clog2(2\*\*FIFO_SIZE):0 | Count of free/filled elements relative to write domain               |
| elem_out_o       | Output    | ELEM_WIDTH               | Output element read from the FIFO (output domain)                    |
| elem_out_clk_i   | Input     | 1                        | Clock for output domain                                              |
| elem_out_valid_o | Output    | 1                        | Valid signal for output element                                      |
| elem_out_ready_i | Input     | 1                        | Ready signal indicating consumption of output element                |
| elem_out_count_o | Output    | $clog2(2\*\*FIFO_SIZE):0 | Count of items available relative to output domain                   |

### clk_div

The `clk_div` module generates the appropriate baud rate clock by dividing the input clock based on the configured clock divider value. It provides timing signals for UART data transmission and reception. The following diagram illustrates the internal structure of the `clk_div` module:

![clk_div](svg/clk_div.svg)

#### Parameters

| Parameter | Description          | Default Value |
| --------- | -------------------- | ------------- |
| DIV_WIDTH | Width of the divider | 4             |

#### Ports

| Port Name | Direction | Width     | Description                                              |
| --------- | --------- | --------- | -------------------------------------------------------- |
| arst_ni   | Input     | 1         | Asynchronous reset, active low                           |
| clk_i     | Input     | 1         | Input clock to be divided                                |
| div_i     | Input     | DIV_WIDTH | Divider value to control output clock toggling frequency |
| clk_o     | Output    | 1         | Output divided clock                                     |

### uart_tx

The `uart_tx` module handles the transmission of data over the UART interface. It manages the serialization of data bytes, adds start, stop, and parity bits as configured, and controls the timing of data output on the TX line. The following diagram illustrates the internal structure of the `uart_tx` module:

![uart_tx](svg/uart_tx.svg)

#### Ports

| Port Name    | Direction | Width | Description                    |
| ------------ | --------- | ----- | ------------------------------ |
| arst_ni      | Input     | 1     | Asynchronous reset, active low |
| clk_i        | Input     | 1     | Clock input                    |
| data_i       | Input     | 8     | Data byte to be transmitted    |
| data_valid_i | Input     | 1     | Data valid signal              |
| data_ready_o | Output    | 1     | Data ready signal              |
| parity_en_i  | Input     | 1     | Parity enable signal           |
| extra_stop_i | Input     | 1     | Extra stop bit enable signal   |
| tx_o         | Output    | 1     | UART transmit data output      |

The FSM for this module is as follows:

![uart_tx_fsm](svg/uart_tx_fsm.svg)

### uart_rx

The `uart_rx` module manages the reception of data from the UART interface. It detects start and stop bits, checks for parity errors, and deserializes incoming data bytes for storage in the RX FIFO. The following diagram illustrates the internal structure of the `uart_rx` module:

![uart_rx](svg/uart_rx.svg)

#### Ports

| Port Name      | Direction | Width | Description                    |
| -------------- | --------- | ----- | ------------------------------ |
| arst_ni        | Input     | 1     | Asynchronous reset, active low |
| clk_i          | Input     | 1     | Clock input                    |
| rx_i           | Input     | 1     | UART receive data input        |
| parity_en_i    | Input     | 1     | Parity enable signal           |
| parity_type_i  | Input     | 1     | Parity type signal             |
| data_o         | Output    | 8     | Received data byte output      |
| data_valid_o   | Output    | 1     | Data valid signal              |
| parity_error_o | Output    | 1     | Parity error indication        |

The FSM for this module is as follows:

![uart_rx_fsm](svg/uart_rx_fsm.svg)

## Additional Diagrams

The following diagram illustrates the clock divider module:

![clk_div](svg/clk_div.svg)

The following diagram shows the refreshed top-level view of the CDC FIFO:

![cdc_fifo](svg/cdc_fifo.svg)

The following diagram provides a detailed description of the CDC FIFO operation:

![cdc_fifo_description](svg/cdc_fifo_description.svg)
