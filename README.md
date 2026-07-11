# UART Transceiver in Verilog

A Universal Asynchronous Receiver Transmitter (UART) Transceiver designed and implemented in **Verilog HDL** using **Xilinx Vivado**. This project demonstrates the complete design flow of a UART communication system, including transmitter, receiver, simulation, and FPGA implementation.

---

## Project Overview

UART (Universal Asynchronous Receiver Transmitter) is one of the most widely used serial communication protocols in embedded systems and digital communication. This project implements a parameterizable UART Transmitter and Receiver from scratch using finite state machines (FSMs) and synchronous digital design techniques.

The design supports standard UART communication consisting of:

- 1 Start Bit
- 8 Data Bits
- 1 Stop Bit
- No Parity (Current Version)

---

## Features

- UART Transmitter (TX)
- UART Receiver (RX)
- Parameterized baud rate generation using `clk_per_bit`
- FSM-based implementation
- LSB-first serial transmission
- Mid-bit sampling in receiver
- Loopback verification (TX connected to RX)
- Functional simulation in Vivado

---

## Project Structure

```
UART_Transceiver
│
├── uart_tx.v          // UART Transmitter
├── uart_rx.v          // UART Receiver
├── baud_gen.v         // Baud Rate Generator
├── top.v              // Top Module
├── top_tb.v           // Testbench
└── README.md
```

---

## UART Frame Format

```
Idle      Start      Data Bits                 Stop
  1    |    0    | D0 D1 D2 D3 D4 D5 D6 D7 |   1
```

- Idle Line = HIGH
- Start Bit = LOW
- Data transmitted LSB first
- Stop Bit = HIGH

---

## UART Transmitter Architecture

The transmitter consists of:

- Baud Rate Counter
- FSM Controller
- Bit Counter
- Serial Output Logic

### Transmitter FSM

```
IDLE
  │
  ▼
START_BIT
  │
  ▼
DATA_BIT
  │
  ▼
STOP_BIT
  │
  ▼
IDLE
```

---

## UART Receiver Architecture

The receiver consists of:

- Start Bit Detector
- Half-bit Synchronization
- Baud Counter
- Bit Counter
- FSM Controller

### Receiver FSM

```
IDLE
  │
  ▼
START_BIT
  │
  ▼
DATA_BIT
  │
  ▼
STOP_BIT
  │
  ▼
IDLE
```

The receiver samples every data bit near its center to improve communication reliability.

---

## Baud Rate Generation

The baud rate timing is parameterized using

```verilog
parameter clk_per_bit = 10;
```

where

```
clk_per_bit = System Clock Frequency / Baud Rate
```

Example:

| System Clock | Baud Rate | clk_per_bit |
|--------------|-----------|-------------|
|100 MHz|9600|10417|
|50 MHz|115200|434|

---

## Simulation

The UART Transmitter and Receiver were verified using Vivado simulation.

Simulation verifies:

- Start bit generation
- Serial transmission
- Data reception
- Stop bit detection
- Successful loopback communication

---

## Tools Used

- Verilog HDL
- Xilinx Vivado
- XSim Simulator

---

## Future Improvements

The following features are planned for future versions:

- Reset support
- Framing Error Detection
- Parity Bit (Even/Odd)
- Configurable Data Length
- Configurable Stop Bits
- Dedicated Baud Rate Generator
- RX/TX FIFO Buffers
- Oversampling Receiver (16x)
- Majority Voting Receiver
- FPGA Hardware Validation

---

## Learning Outcomes

This project helped in understanding:

- UART Communication Protocol
- Finite State Machine (FSM) Design
- Synchronous Digital Design
- Verilog HDL
- Timing and Baud Rate Generation
- Serial Data Transmission
- Receiver Synchronization
- Functional Verification using Vivado

---
