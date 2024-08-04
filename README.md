# Morris Mano Basic Computer in VHDL

This project implements a basic computer system as described in Morris Mano's book **"Computer System Architecture"** using VHDL. The computer architecture includes memory, a CPU with a control unit, and a common bus system.

## Project Overview

The goal of this project is to design and simulate a simple computer system based on the architecture presented by Morris Mano. This includes:

- **Memory:** 16x4096 memory size.
- **CPU:** Comprising a control unit and ALU.
  - **Control Unit:** Manages the control signals for registers, the ALU, the bus, and the state machine for instruction execution.
  - **Common Bus System:** Integrates registers, the ALU, and the bus line to facilitate data transfer.

## Finite State Machine (FSM)

The computer operates using a finite state machine with the following stages:

1. **Fetch:** Retrieve the next instruction from memory.
2. **Decode:** Interpret the instruction to determine required operations.
3. **Indirect/Direct:** Decide the addressing mode and retrieve data if necessary.
4. **Operation:** Execute the instruction using the ALU and other components.

Each operation is associated with a binary value, making it clear during simulation when an instruction is executed.

## Features and Learnings

During this project, I learned:

- How to integrate multiple components with a single clock signal.
- Managing parallel operations that need to execute simultaneously.
- The importance of a structured approach to FSM design in controlling complex operations.

## Current Status

The project is almost complete. The following tasks are pending:

- Implementing I/O operations to allow data exchange between the computer and external devices.
- Extending the state machine to handle new instructions and test programs.

## Installation and Setup

To run this project:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/morris-mano-basic-computer-vhdl.git
