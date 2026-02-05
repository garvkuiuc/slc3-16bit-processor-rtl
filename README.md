### **SLC-3 16-bit Microprocessor RTL Design**

A comprehensive implementation of a 16-bit custom RISC processor based on the LC-3 architecture, designed in SystemVerilog and deployed on a Xilinx FPGA. This project demonstrates an end-to-end hardware engineering workflow: from architectural design and Finite State Machine (FSM) implementation to cycle-accurate simulation and physical hardware validation.

**Architectural Overview**

The processor implements a streamlined Instruction Set Architecture (ISA) including arithmetic (ADD, AND), logic (NOT), control flow (BR, JMP, JSR), and memory operations (LDR, STR).

_The Control FSM (control.sv)_

The heart of the processor is a high-complexity Finite State Machine that coordinates the 16-bit datapath.
- Instruction Sequencing: Manages the complete lifecycle of an instruction across multiple clock cycles, including Fetch, Decode, and Execute.
- Memory Handshaking: Implemented robust state transitions to handle memory latency. Since the design lacks a dedicated hardware 'R' (Ready) signal, I engineered extended wait states within the FSM to ensure data integrity during synchronous memory reads and writes.
- Conditional Logic: Integrated a Branch Enable (BEN) unit to handle conditional branching based on status register flags.

_The 16-bit Datapath (cpu.sv)_

Designed a modular hardware pipeline featuring:
- ALU: Optimized for 16-bit addition and bitwise logic operations.
- Register File: A dual-port 16-bit register file supporting simultaneous source register reads and synchronous destination register writeback.
- Internal Bus Architecture: Implemented a global tri-state bus system with 16-bit steering logic to coordinate data movement between the PC, ALU, MAR, and MDR.

_Verification & Simulation (test_bench_5_1.sv)_

To ensure 100% architectural compliance, the design underwent exhaustive Design Verification (DV).
- Cycle-Accurate Verification: Developed a SystemVerilog testbench to validate the processor against complex diagnostic programs, including a self-modifying code test, a multiplier, and a sorting algorithm.
- Waveform Analysis: Leveraged Vivado to perform deep-trace timing analysis. The simulation waveforms verified deterministic single-cycle timing for internal register transfers and multi-cycle execution for memory-access instructions.

_Signal-Level Debugging & Waveform Analysis_

To verify the internal timing of the 16-bit datapath, I performed cycle-accurate simulations using Vivado. The waveform below illustrates a successful **Instruction Fetch** cycle, showing the precise coordination between the `PC`, `MAR`, and the `GatePC` steering logic.

![Instruction Fetch Waveform](media/fetch_waveform.png)

- This trace confirms that the datapath correctly latches the instruction into the `IR` following the mandated wait states required to synchronize with the memory subsystem.

**FPGA Implementation & Integration**

- Hardware/Software Co-Design: Integrated the CPU with an I/O bridge to interface with FPGA peripherals (LEDs, Switches, and Hex Displays).

- Resource Optimization: Synthesized and routed the design for Xilinx FPGA fabric, ensuring timing closure at target clock frequencies.

- Real-Time Debugging: Utilized the FPGA's hex display grid to output PC and Register contents for real-time architectural tracing during program execution.

**Tech Stack**

Languages: SystemVerilog, Verilog

Tools: Xilinx Vivado, Cadence Xcellium

Target Hardware: Xilinx FPGA

Key Skills: RTL Design, FSM Implementation, Computer Architecture, Design Verification (DV)

**Engineering Challenge: Handling Memory Latency**

A primary challenge was ensuring stable state transitions without a traditional asynchronous memory signal. I resolved this by designing the FSM to insert precise wait cycles, ensuring that the Memory Data Register (MDR) only latches data once the memory subsystem has completed its fetch cycle. This demonstrates a deep understanding of the critical timing paths between a CPU and its memory hierarchy.
