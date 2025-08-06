# UART
A UART module that enables serial data transmission and reception using standard asynchronous protocol. Includes transmit and receive logic with configurable baud rate. Designed for easy integration in FPGA-based digital systems.

⚙️ Design Overview

🔁 Baud Rate Generator

Uses a timer with a sampling rate of 16× and final count 650

Ensures accurate timing for transmission and reception


📥 UART Receiver

16× oversampling for reliable serial data recovery

Data stored in a receiver FIFO for buffered access


📤 UART Transmitter

Sends data from a transmitter FIFO

Handles serial data framing (start/stop bits)


📦 FIFO Buffers

Prevent data loss and decouple UART from system clock

Allow smooth, non-blocking communication



---

🧪 Testbench

Two UARTs (A & B) are connected for full-duplex transfer:

UART A TX → UART B RX

UART B TX → UART A RX


🧪 Test Case

UART A sends: 0x3F

UART B sends: 0xAB


✅ Result

UART A received: 0xAB

UART B received: 0x3F


Demonstrates successful bidirectional communication with FIFOs.

---

👨‍💻 Developed by: Mohab Elsayed
