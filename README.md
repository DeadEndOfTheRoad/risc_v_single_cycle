# RV32I Single-Cycle CPU

## Key Specifications

| Feature | Detail |
| :--- | :--- |
| **Architecture** | Harvard (Dedicated Instruction & Data Memory) |
| **ISA** | RISC-V RV32I (37 Unprivileged Instructions) |
| **Design Type** | Single-Cycle (CPI = 1.0) |
| **HDL** | SystemVerilog (IEEE 1800-2012) |
| **Data Path** | 32-bit (Word-aligned with byte-addressing support) |
| **Control Signals** | 11-signal Hardware Controller |
 
A complete implementation of the RISC-V 32-bit base integer instruction set (RV32I) as a single-cycle processor at the register transfer level. All 37 unprivileged instructions are implemented and verified through simulation.

Behavioural modelling was practiced in SystemVerilog
 
---
 
## Overview
 
This project implements a single-cycle RISC-V CPU from scratch at the register-transfer level (RTL). Every module, from the ALU to the sign extender to the control unit was designed and verified independently (using custom testbenches) before integration into the processor. The design follows the Harvard architecture with separate instruction and data memories.
 
The processor executes one instruction per clock cycle. Each instruction completes the full fetch/decode/execute/memory/writeback path within a single clock period, making the critical path (i.e. the `lw` instruction) the timing constraint.

---
 
## Implemented Instructions
 
All 37 unprivileged RV32I instructions are supported.

---

## Brief microarchitecture breakdown

The processor implements a custom datapath and controller which talk to each other using 11 different control signals.

The controller is a combinational module whereas the datapath is a sequential module (due to the ability of writing to the register file).

A 32-bit ALU is implemented which can perform 10 arithmetic/logic operations:

`add`, `sub`, `and`, `or`, `set less than`, `xor`, `logical left shift`, `logical right shift`, `arithmetic right shift` and `unsigned set less than`

The ALU also implements negative, zero, carry and overflow flag (however they are unused in this RISC-V implementation).

Instruction memory is implemented using ROM which initially reads `risc_v_single_cycle.srcs/sources_1/new/imem.mem` at start of simulation to store instructions.

Data memory is **simulated** by using flip flops to store 32-bit words ( 6-bit width of address bus). The data is conventionally accessed as word-aligned but can be accessed per-byte using `sh/sb` which modifies the 4-bit `memoryWriteEnable` control signal. 

6 N:1 multiplexers are controlled by 6 control signals (`ResultSrc`/`ALUSrc`/`PCSrc`/`PCTargetSrc`/`ImmSrc`/`ReadMask`) to combinationally control dataflow based on operation.

The immediate extender is also a (5:1) multiplexer at heart which is used for unswizzling of instruction bits to extract immediate and sign/zero-extend the immediate based on operation.

---

## Simulation & Verification

Verification accounted for approximately 60% of the development cycle, utilizing a bottom-up testing methodology to ensure system stability.

### Verification Strategy
* **Unit Testing:** Independent SystemVerilog testbenches were developed for the ALU, Control Unit, and Immediate Extender to verify combinatorial logic against the RISC-V ISA spec.
* **System Testing:** The full CPU was verified using hand-written assembly programs. These programs were converted to Hex via [RVCodecJS](https://luplab.gitlab.io/rvcodecjs/) and loaded into `imem.mem`.
* **Waveform Analysis:** Using the **Vivado Simulation Tool**, signal transitions were monitored across the fetch/execute boundary to verify timing, especially for high-latency instructions like `lw`.

### Design Visuals
* **Vivado RTL Elaboration:** Used to generate a complete RTL schematic, providing a gate-level visualization of the synthesized datapath and control logic.
* **Post-Synthesis Functional Simulation:** Ensured that the behavioral SystemVerilog correctly translated into hardware primitives without logic errors.

---

## Tools Used

- Xilinx Vivado 2025.2                                                      -> Elaboration & Simulation
- [RISC-V Instruction Encoder/Decoder](https://luplab.gitlab.io/rvcodecjs/) -> Conversion from assembly to hex and vice versa
- SystemVerilog (IEEE 1800-2012)                                            -> HDL

---

## How To Setup

1) Open `risc_v_single_cycle.xpr` in Xilinx Vivado
2) Navigate to `risc_v_single_cycle.srcs/sources_1/new/imem.mem` and paste hexadecimal representation of assembly instructions to run.
3) Modify testbench to test for expected output (or skip this step).
4) Make sure `testbench.sv` is the `top` and in Tcl console, type `launch_simulation` and click Enter.
5) You can now analyze the waveform produced.

---
