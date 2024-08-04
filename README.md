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

## Simulation

### Simulation 1: Initialization Phase

![Simulation Result 1](https://github.com/user-attachments/assets/859aa880-7b5a-4a44-a16f-f0792a3910e6)

*Explanation:*
- **State (מצב):** Displays the current state of the instruction cycle.
- **on_Bus (משותף):** Indicates which component is sharing data on the common bus.
- **Alu_op (פעולה):** Shows the operation being executed by the Arithmetic Logic Unit.
- **MDIFF (תוצאה):** Memory register used to store the result of a subtraction operation.

### Simulation 2: Instruction Fetch and Decode

![Simulation Result 2](https://github.com/user-attachments/assets/820e7eb2-a386-41b2-8f1a-6c8018c18b43)

*Explanation:*
- **PC (מונה פקודות):** Program Counter showing the sequence of instruction fetch.
- **IR (רשם פקודה):** Instruction Register displaying the current instruction.
- **Bus Activity (פעילות על האוטובוס):** Data flow across the system bus.

### Simulation 3: Execute and Write Back

![Simulation Result 3](https://github.com/user-attachments/assets/16ebb330-e352-422d-a41f-29defc9435cf)

*Explanation:*
- **ALU Operations (פעולות אלוגיות):** Indicates operations performed by the ALU.
- **Memory Write (כתיבה לזיכרון):** Shows data being written back to memory.
- **Register Updates (עדכון רשם):** Updates in register values post-operation.

These simulations provide a detailed view of how instructions are fetched, decoded, and executed. Key aspects include:

- **Reset (rst):** The reset signal to initialize the system.
- **Clock (clk):** The clock signal controlling the operation of the FSM.
- **Instruction Register (IR_reg):** Holds the current instruction being executed.
- **Program Counter (PC_reg):** Points to the next instruction in memory.
- **Memory Address Register (MAR):** Contains the address of the current memory operation.
- **Data Bus (Bus):** Shows the data being transferred between components.

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
