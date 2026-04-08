# 8-Day RTL Practice Plan

| Day | Focus Area | Tasks | Expected Deliverables |
|---|---|---|---|
| **Day 1** | **Basic Combinational RTL** | 1. 2:1 MUX  2. 4:1 MUX  3. 1:2 DEMUX  4. 4-bit Comparator  5. 8:3 Encoder  6. 3:8 Decoder  7. Priority Encoder | RTL for each module, separate testbench, waveform, and brief explanation/truth table |
| **Day 2** | **Intermediate Combinational Design** | 1. 4-bit ALU with add, subtract, AND, OR, XOR, compare, zero flag, carry flag  2. 8-bit Barrel Shifter with logical left, logical right, arithmetic right  3. 4-bit Magnitude Comparator with GT/LT/EQ flags  4. BCD to 7-Segment Decoder  5. 8:1 MUX using only 2:1 MUXes  6. 4-bit Adder/Subtractor using Full Adders only | Clean RTL, modular design, self-checking testbench, waveform proving each operation |
| **Day 3** | **Intermediate Sequential RTL** | 1. Universal Shift Register with hold, shift left, shift right, parallel load  2. Programmable Counter with up/down control, synchronous reset, loadable start value, terminal count flag  3. Sequence Detector using shift-register approach  4. Edge Detector for rising, falling, and both edges  5. Pulse Stretcher/Pulse Extender  6. Clock Divider (/2, /4, bonus: odd divide ratio) | RTL, clocked testbench, waveform, short write-up explaining sequential behavior |
| **Day 4** | **Counters and Shift Registers** | 1. 3-bit Up Counter  2. 3-bit Down Counter  3. Mod-10 Counter  4. Up/Down Counter  5. Ring Counter  6. Johnson Counter  7. SISO Shift Register  8. SIPO Shift Register  9. PISO Shift Register  10. PIPO Register | RTL + testbench for each, waveforms, and a note on sequence progression |
| **Day 5** | **FSM Design** | 1. Sequence Detector for `1011`  2. Sequence Detector for `1101` with overlap  3. Traffic Light Controller  4. Vending Machine Controller  5. Simple 2-Floor Elevator Controller | State diagram, state table, RTL, testbench, simulation proof |
| **Day 6** | **Practical Storage and Utility Blocks** | 1. Single-Port RAM  2. Register File  3. Small FIFO with full/empty flags  4. LFSR  5. Pulse Generator  6. Debouncer | RTL, testbench, corner-case coverage, waveform, and explanation of flags/behavior |
| **Day 7** | **Parameterized Reusable RTL** | 1. Parameterized MUX  2. Parameterized Register  3. Parameterized Counter  4. Parameterized Shift Register  5. Parameterized ALU | Generic RTL using parameters, testbench run for multiple widths/configurations |
| **Day 8** | **Integration Mini Project** | Choose **one**:  1. Stopwatch  2. Vending Machine  3. UART Transmitter  4. Traffic Controller with Pedestrian Request | Block diagram, RTL, testbench, waveform, and short report describing module integration |

---

# Evaluation Criteria
You can review their work using this:

| Criteria | Marks |
|---|---:|
| Functionality | 4 |
| Coding Style | 2 |
| Testbench Quality | 2 |
| Explanation / Understanding | 2 |

**Total: 10 marks per task**

---

# Recommended Priority
If someone cannot finish all tasks, the order of priority should be:

## Must Complete
- Day 1 fully
- Day 2 ALU, barrel shifter, BCD to 7-segment
- Day 3 universal shift register, programmable counter, edge detector
- Day 5 at least 2 FSMs
- Day 8 mini-project

## Good to Complete
- Day 4 fully
- Day 6 RAM, FIFO, register file
- Day 7 parameterized versions
