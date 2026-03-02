# Protocol Converter

## Overview

The protocol converter is a component that translates between a custom protocol to APB. It allows a custom master to communicate with APB slaves by converting the custom protocol signals into APB signals. The converter handles the necessary handshaking and timing requirements to ensure proper communication between the two protocols.

## Signals

### Global Signals

| Signal Name | Source   | Destination        | Description                     |
| ----------- | -------- | ------------------ | ------------------------------- |
| `arst_ni`   | External | Protocol Converter | Asynchronous reset (active low) |
| `clk_i`     | External | Protocol Converter | Clock input                     |

### Custom Protocol Signals

| Signal Name   | Source             | Destination        | Description                        |
| ------------- | ------------------ | ------------------ | ---------------------------------- |
| `c_addr_i`    | Custom Master      | Protocol Converter | Control Channel Address input      |
| `c_wenable_i` | Custom Master      | Protocol Converter | Control Channel Write Enable input |
| `c_valid_i`   | Custom Master      | Protocol Converter | Control Channel Valid input        |
| `c_ready_o`   | Protocol Converter | Custom Master      | Control Channel Ready output       |
|               |                    |                    |                                    |
| `w_data_i`    | Custom Master      | Protocol Converter | Write Data input                   |
| `w_strb_i`    | Custom Master      | Protocol Converter | Write Strobe input                 |
| `w_valid_i`   | Custom Master      | Protocol Converter | Write Data Valid input             |
| `w_ready_o`   | Protocol Converter | Custom Master      | Write Data Ready output            |
|               |                    |                    |                                    |
| `r_data_o`    | Protocol Converter | Custom Master      | Read Data output                   |
| `r_valid_o`   | Protocol Converter | Custom Master      | Read Data Valid output             |
| `r_ready_i`   | Custom Master      | Protocol Converter | Read Data Ready input              |
|               |                    |                    |                                    |
| `b_slverr_o`  | Protocol Converter | Custom Master      | Response Slave Error output        |
| `b_valid_o`   | Protocol Converter | Custom Master      | Response Valid output              |
| `b_ready_i`   | Custom Master      | Protocol Converter | Response Ready input               |

### Advanced Peripheral Bus (APB) Protocol Signals

| Signal Name | Source             | Destination        | Description             |
| ----------- | ------------------ | ------------------ | ----------------------- |
| `psel_o`    | Protocol Converter | APB Slave          | APB Select output       |
| `penable_o` | Protocol Converter | APB Slave          | APB Enable output       |
|             |                    |                    |                         |
| `paddr_o`   | Protocol Converter | APB Slave          | APB Address output      |
| `pwrite_o`  | Protocol Converter | APB Slave          | APB Write output        |
| `pwdata_o`  | Protocol Converter | APB Slave          | APB Write Data output   |
| `pstrb_o`   | Protocol Converter | APB Slave          | APB Write Strobe output |
|             |                    |                    |                         |
| `pready_i`  | APB Slave          | Protocol Converter | APB Ready input         |
| `prdata_i`  | APB Slave          | Protocol Converter | APB Read Data input     |
| `pslverr_i` | APB Slave          | Protocol Converter | APB Slave Error input   |

## Functionality

### Write Operation (Custom Protocol)

1. The custom master initiates a write operation by setting the `c_addr_i` anda asserting `c_wenable_i` signals, and asserting `c_valid_i`. The protocol converter waits for the `c_ready_o` signal to be asserted. After that `c_valid_i` is deasserted.
2. The custom master then provides the write data and strobe signals through `w_data_i` and `w_strb_i`, asserting `w_valid_i`. The protocol converter waits for the `w_ready_o` signal to be asserted. After that `w_valid_i` is deasserted.
3. The custom master asserts `b_ready_i` to indicate that it is ready to receive the response. The protocol converter waits for the `b_valid_o` signal to be asserted, indicating that the response is valid. After that `b_ready_i` is deasserted. The `b_slverr_o` signal indicates if there was a slave error during the write operation.

### Read Operation (Custom Protocol)

1. The custom master initiates a read operation by setting the `c_addr_i` signal and deasserting `c_wenable_i`, then asserting `c_valid_i`. The protocol converter waits for the `c_ready_o` signal to be asserted. After that `c_valid_i` is deasserted.
2. The custom master asserts `r_ready_i` to indicate that it is ready to receive the read data. The protocol converter waits for the `r_valid_o` signal to be asserted, indicating that the read data is valid. After that `r_ready_i` is deasserted. The `r_data_o` signal carries the read data from the APB slave.
3. The custom master asserts `b_ready_i` to indicate that it is ready to receive the response. The protocol converter waits for the `b_valid_o` signal to be asserted, indicating that the response is valid. After that `b_ready_i` is deasserted. The `b_slverr_o` signal indicates if there was a slave error during the read operation.

### APB Communication

Refer APB protocol specifications for detailed timing and signal behavior during APB transactions. [APB Protocol Specifications](https://documentation-service.arm.com/static/63fe2c1356ea36189d4e79f3)

## Internal State Machine

![FSM](protocol_cvtr.svg)
