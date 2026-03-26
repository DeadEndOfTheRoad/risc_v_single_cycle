# RV32I Single-Cycle CPU
 
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

Data memory is **simulated** by using flip flops to store 32-bit words (5-bit width of address bus). The data is conventially accessed as word-aligned but can be accessed per-byte using `sh/sb` which modifies the 4-bit `memoryWriteEnable` control signal. 

6 N:1 multiplexers are controlled by 6 control signals (`ResultSrc`/`ALUSrc`/`PCSrc`/`PCTargetSrc`/`ImmSrc`/`ReadMask`) to combinationally control dataflow based on operation.

The immediate extender is also a (5:1) multiplexer at heart which is used for unswizzling of instruction bits to extract immediate and sign/zero-extend the immediate based on operation.

---

## Simulation

Custom hand written testbenches are used for ALU, controller, and processor with hand written tests in assembly (converted to hex using https://luplab.gitlab.io/rvcodecjs/) which are then written into `imem.mem` before simulation. 

The Vivado Simulation Tool produced waveforms which can be used for debugging and testing (which was also about 50-60% of the time taken in this project)

The Vivado RTL Elaboration Tool can be used to produce a gate/module-level diagram (the RTL 

---

## Tools Used

- Vivado                                                                    -> Elaboration & Simulation
- [RISC-V Instruction Encoder/Decoder](https://luplab.gitlab.io/rvcodecjs/) -> Conversion from assembly to hex and vice versa
- SystemVerilog (IEEE 1800-2012)                                            -> HDL
